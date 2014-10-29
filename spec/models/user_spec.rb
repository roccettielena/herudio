RSpec.describe User do
  subject { FactoryGirl.build(:user) }

  it 'is valid' do
    expect(subject).to be_valid
  end

  it 'validates the presence of a group' do
    expect(subject).to validate_presence_of(:group)
  end
end
