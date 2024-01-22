# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Speaker, type: :model do
  it 'is invalid insertion of more than 10 records' do
    roulette = Roulette.create
    FactoryBot.create_list(:speaker, 9, roulette:)
    tenth_speaker = FactoryBot.build(:speaker, roulette:)
    expect(tenth_speaker).to be_valid
    tenth_speaker.save
    tenth_speaker.name = 'update name'
    expect(tenth_speaker.save).to eq true
    eleventh_speaker = FactoryBot.build(:speaker, roulette:)
    eleventh_speaker.valid?
    expect(eleventh_speaker).to be_invalid
    expect(eleventh_speaker.errors[:roulette]).to include('登録できるのは10件までです')
  end

  it 'create 4 initial records' do
    roulette = Roulette.create
    expect do
      Speaker.create_initial_records(roulette)
    end.to change(roulette.speakers, :count).from(0).to(4)
  end
end
