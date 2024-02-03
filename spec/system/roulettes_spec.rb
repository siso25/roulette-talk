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
    click_button 'コピー'
    cdp_permission = {
      origin: page.server_url,
      permission: { name: 'clipboard-read' },
      setting: 'granted'
    }
    page.driver.browser.execute_cdp('Browser.setPermission', **cdp_permission)
    copied_url = evaluate_async_script('navigator.clipboard.readText().then(arguments[0])')
    current_url = evaluate_script('location.href')
    expect(page.find('input').value).to eq current_url
    expect(copied_url).to eq current_url
  end

  scenario 'it displays warning message when it has no talk themes' do
    roulette = Roulette.create
    FactoryBot.create(:speaker, roulette:)
    visit roulette_path(roulette)
    expect(page).to have_content('トークテーマと話す人を1件以上登録してください。')
    FactoryBot.create(:talk_theme, roulette:)
    visit roulette_path(roulette)
    expect(page).to_not have_content('トークテーマと話す人を1件以上登録してください。')
  end

  scenario 'it displays warning message when it has no speakers' do
    roulette = Roulette.create
    FactoryBot.create(:talk_theme, roulette:)
    visit roulette_path(roulette)
    expect(page).to have_content('トークテーマと話す人を1件以上登録してください。')
    FactoryBot.create(:speaker, roulette:)
    visit roulette_path(roulette)
    expect(page).to_not have_content('トークテーマと話す人を1件以上登録してください。')
  end

  scenario 'it displays result stored in session storage', js: true do
    visit roulette_path(@roulette)
    click_button 'スタート'
    result_text = find "[data-rotate-target='resultText']", wait: 10
    session_storage_items = JSON.parse(evaluate_script("sessionStorage.getItem('#{@roulette.id}')"))
    expect(result_text).to have_content(session_storage_items['talkResult'])
    expect(result_text).to have_content(session_storage_items['speakerResult'])
    expect(find('#talk_themes_list').find('.line-through')).to have_content session_storage_items['talkResult']
    expect(find('#speakers_list').find('.line-through')).to have_content session_storage_items['speakerResult']

    talk_transform = find('.roulette__theme').style('transform')['transform'].delete(' ')[/[0-9.,-]+/].split(',').map(&:to_f)
    # 点の位置から角度を算出する
    talk_rotate_angle = (Math.atan2(talk_transform[1], talk_transform[0]) * 180 / Math::PI).round
    talk_lottery_result = [0, 1, 2, 3].difference(session_storage_items['talk'])
    talk_deg = (45 - 90 * talk_lottery_result[0]).to_f.round
    # 初期状態で4番目の要素は上側にあるので、4番目の要素が選ばれた時だけ一周分足す
    talk_deg_processed = talk_deg < -180 ? talk_deg + 360 : talk_deg
    # 真ん中で止まった位置を0としてプラスマイナス44の範囲に収まっているか検証
    expect(talk_rotate_angle).to be >= talk_deg_processed - 44
    expect(talk_rotate_angle).to be <= talk_deg_processed + 44

    speaker_transform = find('.roulette__speaker').style('transform')['transform'].delete(' ')[/[0-9.,-]+/].split(',').map(&:to_f)
    speaker_rotate_angle = (Math.atan2(speaker_transform[1], speaker_transform[0]) * 180 / Math::PI).round
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
    expect(find('#talk_themes_list')).to have_selector '.line-through'
    expect(find('#speakers_list')).to have_selector '.line-through'
    click_button 'スタート'
    find "[data-rotate-target='resultText']", wait: 10
    session_storage_items1 = JSON.parse(evaluate_script("sessionStorage.getItem('#{roulette.id}')"))
    expect(session_storage_items1['talk'].size).to eq 0
    expect(session_storage_items1['speaker'].size).to eq 0
    expect(find('#talk_themes_list')).not_to have_selector '.line-through'
    expect(find('#speakers_list')).not_to have_selector '.line-through'
    click_button 'スタート'
    find "[data-rotate-target='resultText']", wait: 10
    # session storageがリセットされた上で一回ルーレットが実行されるのでsizeは1になる
    session_storage_items2 = JSON.parse(evaluate_script("sessionStorage.getItem('#{roulette.id}')"))
    expect(session_storage_items2['talk'].size).to eq 1
    expect(session_storage_items2['speaker'].size).to eq 1
  end

  scenario 'user resets roulette', js: true do
    visit roulette_path(@roulette)
    click_button 'スタート'
    find "[data-rotate-target='resultText']", wait: 10
    session_storage_items1 = JSON.parse(evaluate_script("sessionStorage.getItem('#{@roulette.id}')"))
    expect(session_storage_items1['talk'].size).to eq 3
    expect(session_storage_items1['speaker'].size).to eq 3
    expect(find('#talk_themes_list')).to have_selector '.line-through'
    expect(find('#speakers_list')).to have_selector '.line-through'
    click_button 'リセット'
    session_storage_items2 = JSON.parse(evaluate_script("sessionStorage.getItem('#{@roulette.id}')"))
    expect(session_storage_items2['talk'].size).to eq 4
    expect(session_storage_items2['speaker'].size).to eq 4
    expect(find('#talk_themes_list')).not_to have_selector '.line-through'
    expect(find('#speakers_list')).not_to have_selector '.line-through'
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
