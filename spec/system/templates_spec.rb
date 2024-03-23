# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Templates', type: :system do
  scenario 'user successfully copies roulette', js: true do
    roulette = Roulette.create
    FactoryBot.create_list(:talk_theme, 6, roulette:)
    FactoryBot.create_list(:speaker, 3, roulette:)
    visit roulette_path(roulette)
    click_link 'トークテーマをコピーして新規作成'
    expect(page).to have_content('新規ルーレットを作成しました。話す人を登録して使い始めましょう！')
    expect(page).to have_content('トークテーマと話す人を1件以上登録してください。')
    new_roulette = Roulette.find(current_url.split('/').last)
    expect(new_roulette.id).not_to eq roulette.id
    expect(new_roulette.talk_themes.count).to eq 6
    expect(new_roulette.speakers.count).to eq 0
  end

  scenario 'user successfully copies roulette when there is no speaker', js: true do
    roulette = Roulette.create
    FactoryBot.create_list(:talk_theme, 3, roulette:)
    visit roulette_path(roulette)
    click_link 'トークテーマをコピーして新規作成'
    expect(page).to have_content('新規ルーレットを作成しました。話す人を登録して使い始めましょう！')
    expect(page).to have_content('トークテーマと話す人を1件以上登録してください。')
    new_roulette = Roulette.find(current_url.split('/').last)
    expect(new_roulette.id).not_to eq roulette.id
    expect(new_roulette.talk_themes.count).to eq 3
  end

  scenario 'user fails to copy roulette when there is no talk theme', js: true do
    roulette = Roulette.create
    FactoryBot.create_list(:talk_theme, 0, roulette:)
    FactoryBot.create_list(:speaker, 3, roulette:)
    visit roulette_path(roulette)
    click_link 'トークテーマをコピーして新規作成'
    expect(page).to have_content('ルーレットの作成に失敗しました。トークテーマは一件以上登録してください。')
    expect(current_url.split('/').last).to eq roulette.id
  end
end
