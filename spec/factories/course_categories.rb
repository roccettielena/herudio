# frozen_string_literal: true
FactoryGirl.define do
  factory :course_category do
    sequence(:name) { |n| "Category #{n}" }
  end
end
