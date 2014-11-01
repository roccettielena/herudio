FactoryGirl.define do
  factory :user_group do
    name { SecureRandom.hex }
  end
end
