FactoryGirl.define do
  factory :time_frame do
    starts_at { Time.now }
    ends_at { (starts_at || Time.now) + 1.hour }
  end
end
