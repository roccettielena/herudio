require 'rails_helper'

RSpec.describe Course do
  subject { FactoryGirl.build(:course) }

  it 'is valid' do
    expect(subject).to be_valid
  end

  %w(name description location seats category).each do |attribute|
    it "validates the presence of #{attribute}" do
      expect(subject).to validate_presence_of(attribute)
    end
  end

  it 'validates the uniqueness of name' do
    FactoryGirl.create(:course)
    expect(subject).to validate_uniqueness_of(:name)
  end

  it 'validates the numericality of seats (only integer, greater than 0)' do
    expect(subject).to validate_numericality_of(:seats).is_greater_than(0)
  end

  it 'validates there is at least one organizer' do
    expect(FactoryGirl.build(:course, organizers: [])).not_to be_valid
  end

  describe '.by_name' do
    let!(:matching_course) { FactoryGirl.create(:course, name: 'Foocourse') }
    let!(:nonmatching_course) { FactoryGirl.create(:course, name: 'Barcourse') }

    it 'returns the courses matching the given query' do
      expect(Course.by_name('foo')).to eq([matching_course])
    end
  end

  describe '.by_category' do
    let!(:matching_course) { FactoryGirl.create(:course) }
    let!(:nonmatching_course) { FactoryGirl.create(:course) }

    it 'returns the courses belonging to the given category' do
      expect(Course.by_category(matching_course.category)).to eq([matching_course])
    end
  end
end
