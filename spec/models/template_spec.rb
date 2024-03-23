# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Template, type: :model do
  it 'create talk themes' do
    roulette = Roulette.create
    talk_theme1 = TalkTheme.new(theme: 'コピーするトークテーマ1')
    talk_theme2 = TalkTheme.new(theme: 'コピーするトークテーマ2')
    talk_theme3 = TalkTheme.new(theme: 'コピーするトークテーマ3')
    talk_theme4 = TalkTheme.new(theme: 'コピーするトークテーマ4')
    talk_theme5 = TalkTheme.new(theme: 'コピーするトークテーマ5')
    talk_themes = [talk_theme1, talk_theme2, talk_theme3, talk_theme4, talk_theme5]
    expect do
      Template.create_talk_themes(roulette, talk_themes)
    end.to change(roulette.talk_themes, :count).from(0).to(5)
  end
end
