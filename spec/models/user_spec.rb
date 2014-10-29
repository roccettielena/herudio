RSpec.describe User do
  subject { FactoryGirl.build(:user) }

  it 'is valid' do
    expect(subject).to be_valid
  end

  %w(full_name group).each do |attribute|
    it "validates the presence of #{attribute}" do
      expect(subject).to validate_presence_of(attribute)
    end
  end
end
