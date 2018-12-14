source 'https://rubygems.org'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end


gem 'rails', '~> 5.1.4'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
# gem 'therubyracer', platforms: :ruby
gem 'coffee-rails', '~> 4.2'
# gem 'turbolinks', '~> 5'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
gem 'devise'
gem 'slim-rails'
gem 'skim'
gem 'gon'
gem 'responders'
gem 'omniauth'
gem 'omniauth-vkontakte'
gem 'cancancan'
gem 'doorkeeper', '4.2.6'
gem 'therubyracer'
gem 'twitter-bootstrap-rails'
gem 'font-awesome-rails'
gem 'active_model_serializers'
gem 'oj'
gem 'oj_mimic_json'
#gem 'delayed_job_active_record'
gem 'sidekiq'
gem 'whenever'
gem 'sinatra', '>= 1.3.0', require: nil
gem 'letter_opener'
gem 'mysql2'
gem 'thinking-sphinx'
gem 'carrierwave'
gem 'cocoon'
gem 'remotipart'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'dotenv-rails'
gem 'unicorn'
gem 'redis-rails'


group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'selenium-webdriver'
  gem 'factory_bot_rails'
  gem 'rspec-rails'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano3-unicorn', require: false
end

group :test do
  gem 'launchy'
  gem 'shoulda-matchers'
  gem 'rails-controller-testing'
  gem 'json_spec'
end
