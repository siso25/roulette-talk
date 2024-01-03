require 'rails_helper'

RSpec.describe "Roulettes", type: :system do
  before do
    @roulette = Roulette.create
    FactoryBot.create_list(:talk_theme, 4, roulette: @roulette)
    FactoryBot.create_list(:speaker, 4, roulette: @roulette)
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
end
