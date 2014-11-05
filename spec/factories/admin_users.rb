FactoryGirl.define do
  factory :admin_user do
    full_name { Faker::Name.name }
    email { Faker::Internet.email }
    password { SecureRandom.hex }
  end
end
