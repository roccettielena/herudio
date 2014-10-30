FactoryGirl.define do
  factory :course do
    sequence(:name) { |n| "Course #{n}" }
    description { Faker::Lorem.paragraphs(5).join("\n\n") }
  end
end
