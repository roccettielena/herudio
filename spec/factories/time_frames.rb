# frozen_string_literal: true
FactoryGirl.define do
  factory :time_frame do
    starts_at { Time.zone.now }
    ends_at { (starts_at || Time.zone.now) + 1.hour }
  end
end
