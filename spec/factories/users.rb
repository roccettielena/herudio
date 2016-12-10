# frozen_string_literal: true
FactoryGirl.define do
  factory :user do
    association :group, factory: :user_group
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    birth_date { Time.zone.today - 20.years }
    birth_location 'Roma'
    email { Faker::Internet.email }
    password { SecureRandom.hex }
    confirmed_at { Time.zone.now }
  end
end
