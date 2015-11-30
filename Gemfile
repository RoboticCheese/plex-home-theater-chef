# Encoding: UTF-8

source 'https://rubygems.org'

group :development do
  gem 'yard-chef'
  gem 'guard'
  gem 'guard-foodcritic'
  gem 'guard-rspec'
  gem 'guard-kitchen'
end

group :test do
  gem 'rake'
  gem 'rubocop'
  gem 'foodcritic'
  gem 'rspec'
  gem 'chefspec'
  gem 'simplecov'
  gem 'simplecov-console'
  gem 'coveralls'
  gem 'fauxhai'
  gem 'test-kitchen'
  gem 'kitchen-localhost'
  gem 'kitchen-vagrant'
  gem 'winrm-transport'
end

group :integration do
  gem 'serverspec'
  gem 'cucumber'
end

group :deploy do
  gem 'stove'
end

group :production do
  gem 'chef', '>= 12.5'
  gem 'berkshelf'
end
