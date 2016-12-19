# frozen_string_literal: true
FactoryGirl.define do
  factory :authorized_user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    association :group, factory: :user_group
    birth_location { Faker::Address.city }
    birth_date { Time.zone.today - 18.years }
  end
end
