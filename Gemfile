# frozen_string_literal: true

## 中身いじったらbundle installとserverのリロードが必要そうやね

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0.4', '>= 7.0.4.3'

gem 'active_model_serializers' # レスポンスを綺麗にしてくれる
gem 'active_storage_validations', '0.9.8'
gem 'autoprefixer-rails'
gem 'bcrypt', '3.1.18'
gem 'jwt'
gem 'rails-controller-testing'
gem 'rexml', '~> 3.2', '>= 3.2.4'

gem 'image_processing', '1.12.2'

# js
gem "jsbundling-rails"

## css
gem 'cssbundling-rails', '~> 1.1'

## 架空のユーザ名作ってくれる
## 今回は本番環境でも使うけど普通はしないから一応注意
gem 'faker', '2.21.0'

## ページネーション
gem 'kaminari'
gem 'bootstrap5-kaminari-views'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.4'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 5.0'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]

  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'webmock'

  github 'timedia/styleguide', glob: 'ruby/**/*.gemspec' do
    gem 'rubocop-config-timedia', require: false
  end
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'guard'
  gem 'web-console'
  # code format
  gem 'prettier'
  gem 'prettier_print'
  gem 'syntax_tree'
  gem 'syntax_tree-haml'
  gem 'syntax_tree-rbs'
  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  gem 'solargraph'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver', '~> 4.0.0'
  gem 'webdrivers'
  gem 'committee-rails'
end

group :production do
  gem 'aws-sdk-s3', '1.114.0', require: false
  gem 'pg', '>=1.1.4'
end
