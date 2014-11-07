FactoryGirl.define do
  factory :course do
    sequence(:name) { |n| "Course #{n}" }
    description { Faker::Lorem.paragraphs(5).join("\n\n") }
    location { "Class #{Random.rand(1..10)}" }
    seats { Random.rand(1..30) }
    association :category, factory: :course_category, strategy: :build
    organizers { [FactoryGirl.build(:user)] }
  end
end
