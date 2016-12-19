# frozen_string_literal: true
RSpec.describe AuthorizedUser do
  subject { build(:authorized_user) }

  it 'is valid' do
    expect(subject).to be_valid
  end

  %w(first_name last_name group birth_date birth_location).each do |attribute|
    it "validates the presence of #{attribute}" do
      expect(subject).to validate_presence_of(attribute)
    end
  end
end
