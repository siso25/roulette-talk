# frozen_string_literal: true

FactoryBot.define do
  factory :roulette do
    id { SecureRandom.uuid unless persisted? }
  end
end
