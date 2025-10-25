# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Talk Themes', type: :system do
  let!(:roulette) { create(:roulette) }

  scenario 'トークテーマの追加', js: true do
    visit "/rails/view_components/talk_themes/component/with_roulette_id?roulette_id=#{roulette.id}"
    expect do
      click_link 'トークテーマを追加する'
      fill_in 'talk_theme[theme]', with: 'トークテーマ テスト'
      click_button '登録'
      expect(find('#talk_themes_list')).to have_content('トークテーマ テスト')
    end.to change(roulette.talk_themes, :count).by(1)
  end

  scenario 'トークテーマの編集', js: true do
    create(:talk_theme, roulette: roulette)
    visit "/rails/view_components/talk_themes/component/with_roulette_id?roulette_id=#{roulette.id}"
    within '#talk_themes_list' do
      click_link 'トークテーマ', match: :first
      fill_in 'talk_theme[theme]', with: 'トークテーマ 修正'
      click_button '更新'
    end
    expect(find('#talk_themes_list')).to have_content('トークテーマ 修正')
  end

  scenario 'トークテーマの削除', js: true do
    create_list(:talk_theme, 2, roulette: roulette)
    visit "/rails/view_components/talk_themes/component/with_roulette_id?roulette_id=#{roulette.id}"
    talk_theme = find('#talk_themes_list').find('a', match: :first).text
    expect do
      within '#talk_themes_list' do
        find('img', visible: false, match: :first).click
        expect(page).to_not have_content(talk_theme)
        expect(page.all('li').count).to eq 1
      end
    end.to change(roulette.talk_themes, :count).by(-1)
    expect(find('#talk_themes_list')).to_not have_content(talk_theme)
  end
end
