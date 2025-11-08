# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Speakers::Component, type: :component do
  let(:roulette) { build(:roulette) }

  context '話す人一覧の表示・非表示' do
    let(:speaker1) { build(:speaker, id: 1, roulette: roulette) }
    let(:speaker2) { build(:speaker, id: 2, roulette: roulette) }
    let(:speaker3) { build(:speaker, id: 3, roulette: roulette) }

    it '話す人が0人' do
      render_inline(described_class.new(speakers: [], roulette: roulette))
      expect(page).to_not have_css('#speakers')
    end

    it '話す人が1人' do
      render_inline(described_class.new(speakers: [speaker1], roulette: roulette))
      expect(page).to have_css('#speakers')
      expect(page).to have_text(speaker1.name)
    end

    it '話す人が2人以上' do
      render_inline(described_class.new(speakers: [speaker1, speaker2, speaker3], roulette: roulette))
      expect(page).to have_text(speaker1.name)
      expect(page).to have_text(speaker2.name)
      expect(page).to have_text(speaker3.name)
    end
  end

  context '話す人の追加ボタンの表示・非表示' do
    it '話す人が9件の場合は追加ボタンを表示' do
      speakers = Array.new(9) { |i| build(:speaker, id: i, roulette: roulette) }
      render_inline(described_class.new(speakers: speakers, roulette: roulette))
      expect(page).to have_text('話す人を追加する')
      expect(page).to_not have_text('話す人は10人以上追加できません')
    end

    it '話す人が10件の場合は追加ボタンを非表示' do
      speakers = Array.new(10) { |i| build(:speaker, id: i, roulette: roulette) }
      render_inline(described_class.new(speakers: speakers, roulette: roulette))
      expect(page).to_not have_text('話す人を追加する')
      expect(page).to have_text('話す人は10人以上追加できません')
    end
  end
end
