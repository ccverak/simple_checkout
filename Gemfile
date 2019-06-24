# frozen_string_literal: true

source "https://rubygems.org"

gem "grape", "~> 1.2.4"

gem "concurrent-ruby-ext"
gem "dotenv"
gem "grape-swagger", "~> 0.33.0"
gem "grape-swagger-entity"
gem "grape-swagger-representable"
gem "oj", "~> 3.6"
gem "rack", "~> 2.0.7"
gem "rollbar"

group :development do
  gem "rubocop", require: false
  gem "rubocop-performance", require: false
end
group :test do
  gem "rack-test", "~> 1.1.0"
  gem "rspec",     "~> 3.8"
end

group :development, :test do
  gem "pry"
  gem "rake", "~> 12.3.2"
end

group :production do
  gem "puma"
end
