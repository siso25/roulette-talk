class Speaker < ApplicationRecord
  belongs_to :roulette
  validates :name, presence: true

  class << self
    def create_initial_records(roulette)
      (1..4).each do |num|
        roulette.speakers.create(name: "ユーザー#{num}")
      end
    end
  end
end
