# frozen_string_literal: true

class Speaker < ApplicationRecord
  belongs_to :roulette
  validates :name, presence: true
  validate :reached_maximum_count_of_registrations

  COLOR_SET = ['#ECACB5', '#9ACDE7', '#DBA6CC', '#E4E0BE', '#91DBB9'].freeze

  class << self
    def create_initial_records(roulette)
      (1..4).each do |num|
        roulette.speakers.create(name: "ユーザー#{num}")
      end
    end
  end

  def reached_maximum_count_of_registrations
    errors.add(:roulette, '登録できるのは10件までです') if roulette.speakers.count >= 10
  end
end
