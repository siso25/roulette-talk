# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TalkTheme, type: :model do
  it 'is valid with a roulette, theme' do
    roulette = Roulette.new
    talk_theme = roulette.talk_themes.build(theme: 'トークテーマ1')
    expect(talk_theme).to be_valid
  end

  it 'is invalid with a theme' do
    roulette = Roulette.new
    talk_theme = roulette.talk_themes.build(theme: nil)
    talk_theme.valid?
    expect(talk_theme.errors[:theme]).to include("can't be blank")
  end

  it 'is invalid insertion of more than 10 records' do
    roulette = Roulette.create
    9.times do
      FactoryBot.create(:talk_theme, roulette:)
    end
    tenth_talk_theme = FactoryBot.build(:talk_theme, roulette:)
    expect(tenth_talk_theme).to be_valid
    tenth_talk_theme.save
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
