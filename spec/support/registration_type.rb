RSpec.configure do |config|
  config.before do
    ENV['REGISTRATION_TYPE'] = 'invitation'
  end

  config.after do
    ENV['REGISTRATION_TYPE'] = 'invitation'
  end
end
