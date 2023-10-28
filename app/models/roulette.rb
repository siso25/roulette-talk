class Roulette < ApplicationRecord
  has_many :talk_themes, dependent: :destroy
end
