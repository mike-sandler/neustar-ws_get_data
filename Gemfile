source "https://rubygems.org"

gem 'savon', '~> 2.2'

group :development do
  gem "yard"
  gem "bundler"
end

group :development, :test do
  gem "rspec", "~> 2.14.0"
  gem 'rake', :require => false

  # code metrics:
  gem "metric_fu"
end

group :test do
  gem 'simplecov'          , :require => false
  gem 'simplecov-rcov-text', :require => false
end
