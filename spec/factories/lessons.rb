# frozen_string_literal: true
FactoryGirl.define do
  factory :lesson do
    association :course, strategy: :build
    association :time_frame, strategy: :build
  end
end
