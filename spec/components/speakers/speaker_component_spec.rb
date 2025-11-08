# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Speakers::Speaker::Component, type: :component do
  let(:roulette) { build(:roulette) }
  let(:speaker) { build(:speaker, id: 1, roulette: roulette) }
  let(:speaker2) { build(:speaker, id: 2, roulette: roulette) }

  it '話す人の名前を表示する' do
    render_inline(described_class.new(speaker: speaker, roulette: roulette))
    expect(page).to have_text(speaker.name)
  end

  it '話す人を複数人表示' do
    render_inline(described_class.with_collection([speaker, speaker2], roulette: roulette))
    expect(page).to have_text(speaker.name)
    expect(page).to have_text(speaker2.name)
  end
end
