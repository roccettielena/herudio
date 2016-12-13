# frozen_string_literal: true
FactoryGirl.define do
  factory :time_frame_group do
    group_date { Time.zone.today }
  end
end
