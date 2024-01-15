# frozen_string_literal: true

class TalkTheme < ApplicationRecord
  belongs_to :roulette
  validates :theme, presence: true
  validate :reached_maximum_count_of_registrations, on: :create

  COLOR_SET = ['#E38692', '#6EB7DB', '#C97FB4', '#E5D972', '#64C99B'].freeze

  class << self
    def create_initial_records(roulette)
      (1..4).each do |num|
        roulette.talk_themes.create(theme: "トークテーマ#{num}")
      end
    end
  end

  def reached_maximum_count_of_registrations
    errors.add(:roulette, '登録できるのは10件までです') if roulette.talk_themes.count >= 10
  end
end
