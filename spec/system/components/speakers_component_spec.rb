# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Speakers', type: :system do
  let!(:roulette) { create(:roulette) }

  scenario '話す人の追加', js: true do
    visit "/rails/view_components/speakers/component/with_roulette_id?roulette_id=#{roulette.id}"
    expect do
      click_link '話す人を追加する'
      fill_in 'speaker[name]', with: 'テストユーザー'
      click_button '登録'
      expect(find('#speakers_list')).to have_content('テストユーザー')
    end.to change(roulette.speakers, :count).by(1)
  end

  scenario '話す人の編集', js: true do
    create(:speaker, roulette: roulette)
    visit "/rails/view_components/speakers/component/with_roulette_id?roulette_id=#{roulette.id}"
    within '#speakers_list' do
      click_link 'ユーザー', match: :first
      fill_in 'speaker[name]', with: 'ユーザー名の修正'
      click_button '更新'
    end
    expect(find('#speakers_list')).to have_content('ユーザー名の修正')
  end

  scenario '話す人の削除', js: true do
    create_list(:speaker, 2, roulette: roulette)
    visit "/rails/view_components/speakers/component/with_roulette_id?roulette_id=#{roulette.id}"
    speaker = find('#speakers_list').find('a', match: :first).text
    expect do
      within '#speakers_list' do
        find('img', visible: false, match: :first).click
        expect(page).to_not have_content(speaker)
        expect(page.all('li').count).to eq 1
      end
    end.to change(roulette.speakers, :count).by(-1)
    expect(find('#speakers_list')).to_not have_content(speaker)
  end
end
