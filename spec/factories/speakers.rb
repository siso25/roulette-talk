# frozen_string_literal: true

FactoryBot.define do
  factory :speaker do
    sequence(:name) { |n| "ユーザー#{n}" }
    association :roulette
  end
end
