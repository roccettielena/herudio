source 'https://rubygems.org'
ruby '2.3.3'

# Ruby on Rails
gem 'rails', '4.2.7'

# Asset processors
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'autoprefixer-rails'

# Assets
gem 'jquery-rails'
gem 'bootstrap-sass'
gem 'font-awesome-rails'

# Authentication
gem 'devise'
gem 'devise_invitable'
gem 'devise-async', git: 'https://github.com/mhfs/devise-async.git', branch: 'devise-4.x'

# Async processing
gem 'sidekiq'

# Internationalization
gem 'rails-i18n'
gem 'devise-i18n'
gem 'will-paginate-i18n'
gem 'kaminari-i18n'

# Configuration
gem 'figaro'

# Views
gem 'haml-rails'
gem 'simple_form'
gem 'high_voltage'
gem 'truncate_html'
gem 'draper'
gem 'will_paginate'
gem 'will_paginate-bootstrap'
gem 'cocoon'

# Active Record
gem 'pg'
gem 'date_validator'
gem 'enumerize'

# JavaScript runtime
gem 'therubyracer', platform: :ruby

# Web server
gem 'thin'

# Process management
gem 'foreman'

# Controllers
gem 'has_scope'

# Administration
gem 'activeadmin', git: 'https://github.com/activeadmin/activeadmin.git'
gem 'just-datetime-picker'
gem 'csv-importer'

group :development do
  # Preloading
  gem 'spring'
  gem 'spring-commands-rspec'

  # Development
  gem 'pry-rails'
  gem 'pry-rescue'

  # Asset logging suppression
  gem 'quiet_assets'

  # Code quality
  gem 'rubocop'
  gem 'rubocop-rspec'
end

group :development, :test do
  # Factories
  gem 'factory_girl_rails'
  gem 'faker'

  # RSpec
  gem 'rspec-rails'
end

group :production do
  # Heroku
  gem 'rails_12factor'
end

group :test do
  # RSpec
  gem 'fuubar'
  gem 'shoulda-matchers'

  # Acceptance testing
  gem 'capybara'
  gem 'launchy'
  gem 'poltergeist'

  # Database cleansing
  gem 'database_cleaner'
end
