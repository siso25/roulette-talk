# frozen_string_literal: true

class Speaker < ApplicationRecord
  belongs_to :roulette
  validates :name, presence: true

  COLOR_SET = ['#ECACB5', '#9ACDE7', '#DBA6CC', '#E4E0BE', '#91DBB9'].freeze

  class << self
    def create_initial_records(roulette)
      (1..4).each do |num|
        roulette.speakers.create(name: "ユーザー#{num}")
      end
    end
  end
end
