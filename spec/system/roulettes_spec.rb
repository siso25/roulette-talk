require 'rails_helper'

RSpec.describe "Roulettes", type: :system do
  before do
    driven_by(:rack_test)
  end

  scenario "user creates a new roulette" do
    visit root_path
    expect do
      click_link "ルーレットを作る"
    end.to change(Roulette.all, :count).by(1)
    expect(page).to have_current_path %r{^/roulettes/[^/]+$}
  end
end
