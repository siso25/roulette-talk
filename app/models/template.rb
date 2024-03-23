# frozen_string_literal: true

class Template < ApplicationRecord
  class << self
    def create_talk_themes(roulette, talk_themes)
      talk_themes.each do |talk_theme|
        roulette.talk_themes.create(theme: talk_theme.theme)
      end
    end
  end
end
