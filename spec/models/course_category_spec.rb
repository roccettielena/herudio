require 'rails_helper'

RSpec.describe CourseCategory do
  subject { FactoryGirl.build(:course_category) }

  it 'is valid' do
    expect(subject).to be_valid
  end

  it 'validates the presence of name' do
    expect(subject).to validate_presence_of(:name)
  end

  it 'validates the uniqueness of name' do
    FactoryGirl.create(:course_category)
    expect(subject).to validate_uniqueness_of(:name)
  end
end
