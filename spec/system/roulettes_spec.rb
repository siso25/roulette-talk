require 'rails_helper'

RSpec.describe "Roulettes", type: :system do
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

  scenario "user opens help modal", js: true do
    visit roulette_path(@roulette)
    click_button '使い方'
    expect(page).to have_css "dialog#help_modal"
  end

  scenario "user copies link on current page", js: true do
    visit roulette_path(@roulette)
    click_button "リンクのコピー"
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

    # TODO: 抽選結果の角度検証をリファクタリングする
    transform = find('.roulette__theme').style('transform')['transform'].delete(' ')[/[0-9.,-]+/].split(',').map(&:to_f)
    talk_result = [0, 1, 2, 3].difference(session_storage_items['talk'])
    talk_deg = (45 - 90 * talk_result[0]).to_f
    # 初期状態で4番目の要素は上側にあるので、4番目の要素が選ばれた時だけ一周分足す
    talk_deg_calc = talk_deg < -180 ? talk_deg + 360 : talk_deg
    # ラベルの中心を0としてプラスマイナス44
    talk_min_deg = talk_deg_calc - 44.0
    talk_max_deg = talk_deg_calc + 44.0
    # 点の位置から角度を算出する
    talk_result_deg = Math.atan2(transform[1], transform[0]) * 180 / Math::PI
    expect(talk_result_deg).to be >= talk_min_deg
    expect(talk_result_deg).to be <= talk_max_deg

    speaker_result = [0, 1, 2, 3].difference(session_storage_items['speaker'])
    speaker_deg = (45 - 90 * speaker_result[0]).to_f
    # 初期状態で4番目の要素は上側にあるので、4番目の要素が選ばれた時だけ一周分足す
    speaker_deg_calc = speaker_deg < -180 ? speaker_deg + 360 : speaker_deg
    # ラベルの中心を0としてプラスマイナス44
    speaker_min_deg = speaker_deg_calc - 44.0
    speaker_max_deg = speaker_deg_calc + 44.0
    # 点の位置から角度を算出する
    speaker_result_deg = Math.atan2(transform[1], transform[0]) * 180 / Math::PI
    expect(speaker_result_deg).to be >= speaker_min_deg
    expect(speaker_result_deg).to be <= speaker_max_deg
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
end
