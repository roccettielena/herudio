FactoryGirl.define do
  factory :subscription do
    association :user, strategy: :build
    association :lesson, strategy: :build
  end
end
