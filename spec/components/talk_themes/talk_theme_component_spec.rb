# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TalkThemes::TalkTheme::Component, type: :component do
  let(:roulette) { build(:roulette) }
  let(:talk_theme) { build(:talk_theme, id: 1, roulette: roulette) }
  let(:talk_theme2) { build(:talk_theme, id: 2, roulette: roulette) }

  it 'トークテーマの名前を表示する' do
    render_inline(described_class.new(talk_theme: talk_theme, roulette: roulette))
    expect(page).to have_text(talk_theme.theme)
  end

  it '複数トークテーマ' do
    render_inline(described_class.with_collection([talk_theme, talk_theme2], roulette: roulette))
    expect(page).to have_text(talk_theme.theme)
    expect(page).to have_text(talk_theme2.theme)
  end
end
