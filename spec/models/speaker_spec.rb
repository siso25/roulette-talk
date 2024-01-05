# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Speaker, type: :model do
  it 'is valid with a roulette, name' do
    roulette = Roulette.new
    speaker = roulette.speakers.build(name: 'ユーザー1')
    expect(speaker).to be_valid
  end

  it 'is invalid with a name' do
    roulette = Roulette.new
    speaker = roulette.speakers.build(name: nil)
    speaker.valid?
    expect(speaker.errors[:name]).to include("can't be blank")
  end

  it 'create 4 initial records' do
    roulette = Roulette.create
    expect do
      Speaker.create_initial_records(roulette)
    end.to change(roulette.speakers, :count).from(0).to(4)
  end
end
