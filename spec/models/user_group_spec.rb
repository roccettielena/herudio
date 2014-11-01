require 'rails_helper'

RSpec.describe UserGroup do
  subject { FactoryGirl.build(:user_group) }

  it 'is valid' do
    expect(subject).to be_valid
  end

  it 'validates the presence of a name' do
    expect(subject).to validate_presence_of(:name)
  end

  it 'validates the uniqueness of the name' do
    FactoryGirl.create(:user_group)
    expect(subject).to validate_uniqueness_of(:name)
  end
end
