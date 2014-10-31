require 'rails_helper'

RSpec.describe Course do
  subject { FactoryGirl.build(:course) }

  it 'is valid' do
    expect(subject).to be_valid
  end

  %w(name description location seats).each do |attribute|
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
end
