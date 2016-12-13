# frozen_string_literal: true
FactoryGirl.define do
  factory :subscription do
    association :user, strategy: :build
    association :lesson, strategy: :build
    origin 'system'
  end
end
