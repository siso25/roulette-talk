FactoryBot.define do
  factory :speaker do
    sequence(:name) { |n| "ユーザー#{n}" }
  end
end
