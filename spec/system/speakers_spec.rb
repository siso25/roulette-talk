# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Speakers', type: :system do
  before do
    @roulette = Roulette.create
    FactoryBot.create_list(:talk_theme, 4, roulette: @roulette)
    FactoryBot.create_list(:speaker, 4, roulette: @roulette)
  end

  scenario 'user adds a speaker', js: true do
    visit roulette_path(@roulette)
    expect(JSON.parse(evaluate_script("sessionStorage.getItem('#{@roulette.id}')"))['speaker'].size).to eq 4
    click_button 'スタート'
    find "[data-rotate-target='resultText']", wait: 10
    expect(find('#talk_themes_list')).to have_selector '.bg-base-300'
    expect(find('#speakers_list')).to have_selector '.bg-base-300'
    expect do
      click_link '話す人を追加する'
      fill_in 'speaker[name]', with: 'ユーザー テスト'
      click_button '登録'
      expect(find('#speakers_list')).to have_content('ユーザー テスト')
    end.to change(@roulette.speakers, :count).by(1)
    expect(find('.speaker__labelContainer')).to have_content('ユーザー テスト')
    expect(JSON.parse(evaluate_script("sessionStorage.getItem('#{@roulette.id}')"))['speaker'].size).to eq 5
    expect(find('#talk_themes_list')).not_to have_selector '.bg-base-300'
    expect(find('#speakers_list')).not_to have_selector '.bg-base-300'
  end

  scenario 'user modifies a speaker', js: true do
    visit roulette_path(@roulette)
    within '#speakers_list' do
      click_link 'ユーザー', match: :first
      fill_in 'speaker[name]', with: 'ユーザー 修正'
      click_button '更新'
    end
    expect(find('#speakers_list')).to have_content('ユーザー 修正')
    expect(find('.speaker__labelContainer')).to have_content('ユーザー 修正')
  end

  scenario 'user deletes a speaker', js: true do
    visit roulette_path(@roulette)
    expect(JSON.parse(evaluate_script("sessionStorage.getItem('#{@roulette.id}')"))['speaker'].size).to eq 4
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
    expect(JSON.parse(evaluate_script("sessionStorage.getItem('#{@roulette.id}')"))['speaker'].size).to eq 3
  end

  scenario 'it toggles a link to text when 10 speakers are registered', js: true do
    FactoryBot.create_list(:speaker, 5, roulette: @roulette)
    visit roulette_path(@roulette)
    expect do
      click_link '話す人を追加する'
      fill_in 'speaker[name]', with: 'ユーザー テスト'
      click_button '登録'
      expect(find('#speakers_list')).to have_content('ユーザー テスト')
    end.to change(@roulette.speakers, :count).by(1)
    new_link_element = find("[data-testid='new-speaker-link']")
    expect(new_link_element).to have_content('話す人は10人以上追加できません')
    expect(new_link_element).to_not have_selector('a')
  end
end
