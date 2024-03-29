# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TalkTheme, type: :model do
  it 'is invalid insertion of more than 10 records' do
    roulette = Roulette.create
    FactoryBot.create_list(:talk_theme, 9, roulette:)
    tenth_talk_theme = FactoryBot.build(:talk_theme, roulette:)
    expect(tenth_talk_theme).to be_valid
    tenth_talk_theme.save
    tenth_talk_theme.theme = 'update talk theme'
    expect(tenth_talk_theme.save).to eq true
    eleventh_talk_theme = FactoryBot.build(:talk_theme, roulette:)
    eleventh_talk_theme.valid?
    expect(eleventh_talk_theme).to be_invalid
    expect(eleventh_talk_theme.errors[:roulette]).to include('登録できるのは10件までです')
  end

  it 'create 4 initial records' do
    roulette = Roulette.create
    expect do
      TalkTheme.create_initial_records(roulette)
    end.to change(roulette.talk_themes, :count).from(0).to(4)
  end
end
