class TalkTheme < ApplicationRecord
  belongs_to :roulette
  validates :theme, presence: true

  COLOR_SET = ['#E38692', '#6EB7DB', '#C97FB4', '#FFF280', '#64C99B']

  class << self
    def create_initial_records(roulette)
      (1..4).each do |num|
        roulette.talk_themes.create(theme: "トークテーマ#{num}")
      end
    end
  end
end
