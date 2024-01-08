# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Roulettes', type: :system do
  before do
    @roulette = Roulette.create
    FactoryBot.create_list(:talk_theme, 4, roulette: @roulette)
    FactoryBot.create_list(:speaker, 4, roulette: @roulette)
  end

  scenario 'user returns to the top page' do
    visit roulette_path(@roulette)
    find('header').find('a').click
    expect(page).to have_content 'ルーレットを作る'
  end

  scenario 'user opens help modal', js: true do
    visit roulette_path(@roulette)
    click_button '使い方'
    expect(page).to have_css 'dialog#help_modal'
  end

  scenario 'user copies link on current page', js: true do
    visit roulette_path(@roulette)
    click_button 'リンクのコピー'
    cdp_permission = {
      origin: page.server_url,
      permission: { name: 'clipboard-read' },
      setting: 'granted'
    }
    page.driver.browser.execute_cdp('Browser.setPermission', **cdp_permission)
    copied_url = evaluate_async_script('navigator.clipboard.readText().then(arguments[0])')
    current_url = evaluate_script('location.href')
    expect(copied_url).to eq current_url
  end

  scenario 'it displays result stored in session storage', js: true do
    visit roulette_path(@roulette)
    click_button 'スタート'
    result_text = find "[data-rotate-target='resultText']", wait: 10
    session_storage_items = JSON.parse(evaluate_script("sessionStorage.getItem('#{@roulette.id}')"))
    expect(result_text).to have_content(session_storage_items['talkResult'])
    expect(result_text).to have_content(session_storage_items['speakerResult'])

    talk_transform = find('.roulette__theme').style('transform')['transform'].delete(' ')[/[0-9.,-]+/].split(',').map(&:to_f)
    # 点の位置から角度を算出する
    talk_rotate_angle = Math.atan2(talk_transform[1], talk_transform[0]) * 180 / Math::PI
    talk_lottery_result = [0, 1, 2, 3].difference(session_storage_items['talk'])
    talk_deg = (45 - 90 * talk_lottery_result[0]).to_f.round
    # 初期状態で4番目の要素は上側にあるので、4番目の要素が選ばれた時だけ一周分足す
    talk_deg_processed = talk_deg < -180 ? talk_deg + 360 : talk_deg
    # 真ん中で止まった位置を0としてプラスマイナス44の範囲に収まっているか検証
    expect(talk_rotate_angle).to be >= talk_deg_processed - 44
    expect(talk_rotate_angle).to be <= talk_deg_processed + 44

    speaker_transform = find('.roulette__speaker').style('transform')['transform'].delete(' ')[/[0-9.,-]+/].split(',').map(&:to_f)
    speaker_rotate_angle = Math.atan2(speaker_transform[1], speaker_transform[0]) * 180 / Math::PI
    speaker_lottery_result = [0, 1, 2, 3].difference(session_storage_items['speaker'])
    speaker_deg = (45 - 90 * speaker_lottery_result[0]).to_f.round
    speaker_deg_processed = speaker_deg < -180 ? speaker_deg + 360 : speaker_deg
    expect(speaker_rotate_angle).to be >= speaker_deg_processed - 44
    expect(speaker_rotate_angle).to be <= speaker_deg_processed + 44
  end

  scenario 'user plays roulette more times than the number of roulette elements', js: true do
    roulette = Roulette.create
    FactoryBot.create_list(:talk_theme, 2, roulette:)
    FactoryBot.create_list(:speaker, 2, roulette:)
    visit roulette_path(roulette)
    click_button 'スタート'
    find "[data-rotate-target='resultText']", wait: 10
    click_button 'スタート'
    find "[data-rotate-target='resultText']", wait: 10
    session_storage_items1 = JSON.parse(evaluate_script("sessionStorage.getItem('#{roulette.id}')"))
    expect(session_storage_items1['talk'].size).to eq 0
    expect(session_storage_items1['speaker'].size).to eq 0
    click_button 'スタート'
    find "[data-rotate-target='resultText']", wait: 10
    # session storageがリセットされた上で一回ルーレットが実行されるのでsizeは1になる
    session_storage_items2 = JSON.parse(evaluate_script("sessionStorage.getItem('#{roulette.id}')"))
    expect(session_storage_items2['talk'].size).to eq 1
    expect(session_storage_items2['speaker'].size).to eq 1
  end

  scenario 'user reset roulette', js: true do
    visit roulette_path(@roulette)
    click_button 'スタート'
    find "[data-rotate-target='resultText']", wait: 10
    session_storage_items1 = JSON.parse(evaluate_script("sessionStorage.getItem('#{@roulette.id}')"))
    expect(session_storage_items1['talk'].size).to eq 3
    expect(session_storage_items1['speaker'].size).to eq 3
    click_button 'リセット'
    session_storage_items2 = JSON.parse(evaluate_script("sessionStorage.getItem('#{@roulette.id}')"))
    expect(session_storage_items2['talk'].size).to eq 4
    expect(session_storage_items2['speaker'].size).to eq 4
  end

  scenario 'user add a talk theme', js: true do
    visit roulette_path(@roulette)
    expect do
      click_link 'トークテーマを追加する'
      fill_in 'talk_theme[theme]', with: 'トークテーマ テスト'
      click_button '登録'
      expect(find('#talk_themes_list')).to have_content('トークテーマ テスト')
    end.to change(@roulette.talk_themes, :count).by(1)
    expect(find('.theme__labelContainer')).to have_content('トークテーマ テスト')
  end

  scenario 'user modify a talk theme', js: true do
    visit roulette_path(@roulette)
    within '#talk_themes_list' do
      click_link 'トークテーマ', match: :first
      fill_in 'talk_theme[theme]', with: 'トークテーマ 修正'
      click_button '更新'
    end
    expect(find('#talk_themes_list')).to have_content('トークテーマ 修正')
    expect(find('.theme__labelContainer')).to have_content('トークテーマ 修正')
  end

  scenario 'user delete a talk theme', js: true do
    visit roulette_path(@roulette)
    talk_theme = find('#talk_themes_list').find('a', match: :first).text
    expect do
      within '#talk_themes_list' do
        find('img', visible: false, match: :first).click
        expect(page).to_not have_content(talk_theme)
        expect(page.all('li').count).to eq 3
      end
    end.to change(@roulette.talk_themes, :count).by(-1)
    expect(find('.theme__labelContainer')).to_not have_content(talk_theme)
    expect(find('.theme__labelContainer').all('li').count).to eq 3
  end

  scenario 'user add a speaker', js: true do
    visit roulette_path(@roulette)
    expect do
      click_link '話す人を追加する'
      fill_in 'speaker[name]', with: 'ユーザー テスト'
      click_button '登録'
      expect(find('#speakers_list')).to have_content('ユーザー テスト')
    end.to change(@roulette.speakers, :count).by(1)
    expect(find('.speaker__labelContainer')).to have_content('ユーザー テスト')
  end

  scenario 'user modify a speaker', js: true do
    visit roulette_path(@roulette)
    within '#speakers_list' do
      click_link 'ユーザー', match: :first
      fill_in 'speaker[name]', with: 'ユーザー 修正'
      click_button '更新'
    end
    expect(find('#speakers_list')).to have_content('ユーザー 修正')
    expect(find('.speaker__labelContainer')).to have_content('ユーザー 修正')
  end

  scenario 'user delete a speaker', js: true do
    visit roulette_path(@roulette)
    speaker = find('#speakers_list').find('a', match: :first).text
    expect do
      within '#speakers_list' do
        expect(page).to have_content(speaker)
        find('img', visible: false, match: :first).click
        expect(page).to_not have_content(speaker)
        expect(page.all('li').count).to eq 3
      end
    end.to change(@roulette.speakers, :count).by(-1)
    expect(find('.speaker__labelContainer')).to_not have_content(speaker)
    expect(find('.speaker__labelContainer').all('li').count).to eq 3
  end

  scenario 'user registers a one-line talk theme', js: true do
    visit roulette_path(@roulette)
    within '#talk_themes_list' do
      click_link 'トークテーマ', match: :first
      fill_in 'talk_theme[theme]', with: '1行'
      click_button '更新'
    end
    expect(find('#talk_themes_list')).to have_content('1行')
    element = find('.theme__label', match: :first)
    line_count = element['clientHeight'].to_i / element.style('line-height')['line-height'][/[0-9.-]+/].to_i
    left = element.style('left')['left'][/[0-9.-]+/].to_f
    top = element.style('top')['top'][/[0-9.-]+/].to_f
    transform = element.style('transform')['transform'].delete(' ')[/[0-9.,-]+/].split(',').map(&:to_f)
    rotate_angle = (Math.atan2(transform[1], transform[0]) * 180 / Math::PI).round
    expect(line_count).to eq 1
    expect(left).to eq 20.2082
    expect(top).to eq(-130.208)
    expect(rotate_angle).to eq(-45)
  end

  scenario 'user registers a two-line talk theme', js: true do
    visit roulette_path(@roulette)
    within '#talk_themes_list' do
      click_link 'トークテーマ', match: :first
      fill_in 'talk_theme[theme]', with: '2行以上のトークテーマを登録する'
      click_button '更新'
    end
    expect(find('#talk_themes_list')).to have_content('2行')
    element = find('.theme__label', match: :first)
    line_count = element['clientHeight'].to_i / element.style('line-height')['line-height'][/[0-9.-]+/].to_i
    left = element.style('left')['left'][/[0-9.-]+/].to_f
    top = element.style('top')['top'][/[0-9.-]+/].to_f
    transform = element.style('transform')['transform'].delete(' ')[/[0-9.,-]+/].split(',').map(&:to_f)
    rotate_angle = (Math.atan2(transform[1], transform[0]) * 180 / Math::PI).round
    expect(line_count).to eq 2
    expect(left).to eq 20.2082
    expect(top).to eq(-140.208)
    expect(rotate_angle).to eq(-45)
  end
end
