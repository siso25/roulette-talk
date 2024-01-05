require 'rails_helper'

RSpec.describe "Homes", type: :system do
  scenario "user creates a new roulette" do
    visit root_path
    expect do
      click_link "ルーレットを作る"
    end.to change(Roulette.all, :count).by(1)
    expect(page).to have_current_path %r{^/roulettes/[^/]+$}
  end

  scenario "user opens term of service", js: true do
    visit root_path
    click_button '利用規約'
    expect(page).to have_css "dialog#term_of_service_modal"
  end

  scenario "user opens privacy policy", js: true do
    visit root_path
    click_button 'プライバシーポリシー'
    expect(page).to have_css "dialog#privacy_policy_modal"
  end
end
