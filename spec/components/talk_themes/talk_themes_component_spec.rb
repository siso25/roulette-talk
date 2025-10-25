# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TalkThemes::Component, type: :component do
  let(:roulette) { build(:roulette) }

  context 'トークテーマ一覧の表示・非表示' do
    let(:talk_theme1) { build(:talk_theme, id: 1, roulette: roulette) }
    let(:talk_theme2) { build(:talk_theme, id: 2, roulette: roulette) }
    let(:talk_theme3) { build(:talk_theme, id: 3, roulette: roulette) }

    it 'トークテーマ0件' do
      render_inline(described_class.new(talk_themes: [], roulette: roulette))
      expect(page).to_not have_css('#talk_themes')
    end

    it 'トークテーマ1件' do
      render_inline(described_class.new(talk_themes: [talk_theme1], roulette: roulette))
      expect(page).to have_css('#talk_themes')
      expect(page).to have_text(talk_theme1.theme)
    end

    it 'トークテーマ2件以上' do
      render_inline(described_class.new(talk_themes: [talk_theme1, talk_theme2, talk_theme3], roulette: roulette))
      expect(page).to have_text(talk_theme1.theme)
      expect(page).to have_text(talk_theme2.theme)
      expect(page).to have_text(talk_theme3.theme)
    end
  end

  context 'トークテーマ追加ボタンの表示・非表示' do
    it 'トークテーマ9件の場合は追加ボタンを表示' do
      talk_themes = Array.new(9) { |i| build(:talk_theme, id: i, roulette: roulette) }
      render_inline(described_class.new(talk_themes: talk_themes, roulette: roulette))
      expect(page).to have_text('トークテーマを追加する')
      expect(page).to_not have_text('トークテーマは10個以上追加できません')
    end

    it 'トークテーマ10件の場合は追加ボタンを非表示' do
      talk_themes = Array.new(10) { |i| build(:talk_theme, id: i, roulette: roulette) }
      render_inline(described_class.new(talk_themes: talk_themes, roulette: roulette))
      expect(page).to_not have_text('トークテーマを追加する')
      expect(page).to have_text('トークテーマは10個以上追加できません')
    end
  end
end
