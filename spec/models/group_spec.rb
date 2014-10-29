require 'rails_helper'

RSpec.describe Group do
  subject { FactoryGirl.build(:group) }

  it 'is valid' do
    expect(subject).to be_valid
  end

  it 'validates the presence of a name' do
    expect(subject).to validate_presence_of(:name)
  end

  it 'validates the uniqueness of the name' do
    FactoryGirl.create(:group)
    expect(subject).to validate_uniqueness_of(:name)
  end
end
