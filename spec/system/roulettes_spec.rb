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
end
