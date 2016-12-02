# frozen_string_literal: true
FactoryGirl.define do
  factory :user do
    full_name { Faker::Name.name }
    email { Faker::Internet.email }
    password { SecureRandom.hex }
    confirmed_at { Time.zone.now }
    association :group, factory: :user_group, strategy: :build
  end
end
