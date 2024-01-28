# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Talk Themes', type: :system do
  before do
    @roulette = Roulette.create
    FactoryBot.create_list(:talk_theme, 4, roulette: @roulette)
    FactoryBot.create_list(:speaker, 4, roulette: @roulette)
  end

  scenario 'user adds a talk theme', js: true do
    visit roulette_path(@roulette)
    expect(JSON.parse(evaluate_script("sessionStorage.getItem('#{@roulette.id}')"))['talk'].size).to eq 4
    click_button 'スタート'
    find "[data-rotate-target='resultText']", wait: 10
    expect(find('#talk_themes_list')).to have_selector '.bg-base-300'
    expect(find('#speakers_list')).to have_selector '.bg-base-300'
    expect do
      click_link 'トークテーマを追加する'
      fill_in 'talk_theme[theme]', with: 'トークテーマ テスト'
      click_button '登録'
      expect(find('#talk_themes_list')).to have_content('トークテーマ テスト')
    end.to change(@roulette.talk_themes, :count).by(1)
    expect(find('.theme__labelContainer')).to have_content('トークテーマ テスト')
    expect(JSON.parse(evaluate_script("sessionStorage.getItem('#{@roulette.id}')"))['talk'].size).to eq 5
    expect(find('#talk_themes_list')).not_to have_selector '.bg-base-300'
    expect(find('#speakers_list')).not_to have_selector '.bg-base-300'
  end

  scenario 'user adds a talk theme when no talk theme is registered and there is one speaker', js: true do
    roulette = Roulette.create
    FactoryBot.create(:speaker, roulette:)
    visit roulette_path(roulette)
    expect(page).to_not have_selector '#talk_themes'
    expect(find('#no_items_roulette')).to have_content('トークテーマと話す人を1件以上登録してください。')
    click_link 'トークテーマを追加する'
    fill_in 'talk_theme[theme]', with: 'トークテーマ テスト'
    click_button '登録'
    expect(find('#talk_themes_list')).to have_content('トークテーマ テスト')
    expect(find('.theme__labelContainer')).to have_content('トークテーマ テスト')
  end

  scenario 'user adds a talk theme when no talk theme is registered and there are no speakers', js: true do
    roulette = Roulette.create
    visit roulette_path(roulette)
    expect(page).to_not have_selector '#talk_themes'
    expect(page).to_not have_selector '#speakers'
    expect(find('#no_items_roulette')).to have_content('トークテーマと話す人を1件以上登録してください。')
    click_link 'トークテーマを追加する'
    fill_in 'talk_theme[theme]', with: 'トークテーマ テスト'
    click_button '登録'
    expect(find('#talk_themes_list')).to have_content('トークテーマ テスト')
    expect(find('#no_items_roulette')).to have_content('トークテーマと話す人を1件以上登録してください。')
  end

  scenario 'user modifies a talk theme', js: true do
    visit roulette_path(@roulette)
    within '#talk_themes_list' do
      click_link 'トークテーマ', match: :first
      fill_in 'talk_theme[theme]', with: 'トークテーマ 修正'
      click_button '更新'
    end
    expect(find('#talk_themes_list')).to have_content('トークテーマ 修正')
    expect(find('.theme__labelContainer')).to have_content('トークテーマ 修正')
  end

  scenario 'user deletes a talk theme', js: true do
    visit roulette_path(@roulette)
    talk_theme = find('#talk_themes_list').find('a', match: :first).text
    expect(JSON.parse(evaluate_script("sessionStorage.getItem('#{@roulette.id}')"))['talk'].size).to eq 4
    expect do
      within '#talk_themes_list' do
        find('img', visible: false, match: :first).click
        expect(page).to_not have_content(talk_theme)
        expect(page.all('li').count).to eq 3
      end
    end.to change(@roulette.talk_themes, :count).by(-1)
    expect(find('.theme__labelContainer')).to_not have_content(talk_theme)
    expect(find('.theme__labelContainer').all('li').count).to eq 3
    expect(JSON.parse(evaluate_script("sessionStorage.getItem('#{@roulette.id}')"))['talk'].size).to eq 3
  end

  scenario 'user deletes a talk theme when one talk theme is registered', js: true do
    roulette = Roulette.create
    FactoryBot.create(:talk_theme, roulette:)
    FactoryBot.create(:speaker, roulette:)
    visit roulette_path(roulette)
    expect(page).to have_selector '#talk_themes'
    find('#talk_themes_list').find('img', visible: false).click
    expect(page).to_not have_selector '#talk_themes'
    expect(find('#no_items_roulette')).to have_content('トークテーマと話す人を1件以上登録してください。')
  end

  scenario 'user deletes a talk theme when one talk theme is registered and there are no speakers', js: true do
    roulette = Roulette.create
    FactoryBot.create(:talk_theme, roulette:)
    visit roulette_path(roulette)
    expect(page).to have_selector '#talk_themes'
    expect(find('#no_items_roulette')).to have_content('トークテーマと話す人を1件以上登録してください。')
    find('#talk_themes_list').find('img', visible: false).click
    expect(page).to_not have_selector '#talk_themes'
    expect(find('#no_items_roulette')).to have_content('トークテーマと話す人を1件以上登録してください。')
  end

  scenario 'it toggles a link to text when 10 themes are registered', js: true do
    FactoryBot.create_list(:talk_theme, 5, roulette: @roulette)
    visit roulette_path(@roulette)
    expect do
      click_link 'トークテーマを追加する'
      fill_in 'talk_theme[theme]', with: 'トークテーマ テスト'
      click_button '登録'
      expect(find('#talk_themes_list')).to have_content('トークテーマ テスト')
    end.to change(@roulette.talk_themes, :count).by(1)
    new_link_element = find("[data-testid='new-talk-theme-link']")
    expect(new_link_element).to have_content('トークテーマは10個以上追加できません')
    expect(new_link_element).to_not have_selector('a')
  end
end
