# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.4.7'

gem 'bigdecimal'
gem 'bootsnap', require: false
gem 'cssbundling-rails'
gem 'drb'
gem 'jbuilder'
gem 'jsbundling-rails'
gem 'meta-tags'
gem 'mutex_m'
gem 'pg'
gem 'puma'
gem 'rails', '7.2.2.2'
gem 'slim-rails'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'rspec-rails'
end

group :development do
  gem 'concurrent-ruby'
  gem 'dockerfile-rails', '>= 1.6'
  gem 'rubocop', require: false
  gem 'rubocop-fjord', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'slim_lint'
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
end
