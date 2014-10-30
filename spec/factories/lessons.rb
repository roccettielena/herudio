FactoryGirl.define do
  factory :lesson do
    association :course, strategy: :build
    starts_at { Time.now }
    ends_at { (starts_at || Time.now) + 1.hour }
  end
end
