# frozen_string_literal: true

FactoryBot.define do
  factory :talk_theme do
    sequence(:theme) { |n| "トークテーマ#{n}" }
  end
end
