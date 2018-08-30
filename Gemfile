source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.4.3'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.1'
# Use Puma as the app server
gem 'puma', '~> 3.11'

# Use mongodb as persistent storage
gem 'mongoid'
# gem 'mongoid_paranoia'
gem 'mongoid-tree', '~> 2.1', :require => 'mongoid/tree'

# Redis
gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
gem 'cryptoexchange'

gem 'faye'
gem 'faye-websocket'
gem 'binance'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
gem 'i18n'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'
#
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

# Authentication
gem 'devise'
gem 'devise-jwt', '~> 0.5.1'

# Authorization
gem 'pundit', '~> 1.1'

# Request store
gem 'request_store_rails', '~> 1.0', '>= 1.0.3'

# Dry-transaction
gem 'dry-transaction', '0.11.2'
gem 'dry-validation'
gem 'dry-initializer'
# Image upload
# gem 'carrierwave-mongoid', require: 'carrierwave/mongoid'

# Cloud storage
gem 'fog-aws'

# Use JSON serialization like a boss
gem 'active_model_serializers'

# Pagination
gem 'kaminari', '~> 1.0', '>= 1.0.1'
gem 'kaminari-mongoid', '~> 1.0', '>= 1.0.1'

# Money
# gem 'money-rails', '~> 1.9'

# Use redis object for session store
gem 'connection_pool'
gem 'redis-objects'

# HTTP request/response
gem 'httparty', "~> 0.15.6"
gem 'savon'

# Roo provides an interface to spreadsheets of several sorts.
gem "roo", "~> 2.7.0"

# For API docs
gem 'swagger-blocks'


# Sidekiq
gem 'sidekiq'

# Sidekiq
gem 'kucoin'
gem 'rest-client'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end


group :development do
  # Use Puma as the app server
  gem 'puma', '~> 3.11'

  gem 'dotenv-rails'

  gem 'listen', '~> 3.1'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # An IRB alternative and runtime developer console
  gem 'pry-byebug'
  gem 'pry-rails'

  # Log HTTP
  gem 'httplog'

  # Deploy project with capistrno
  gem 'capistrano'
  gem 'capistrano-env-config'
  gem 'capistrano-passenger'
  gem 'capistrano-rails', '~> 1.3'
  gem 'capistrano-rvm'

  # Test factories
  gem 'factory_bot_rails'
  gem 'ffaker', '~> 2.6'

  # UML diagrams of the database
  gem 'railroady'

  # Pretty prints Ruby objects
  gem 'awesome_print'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

