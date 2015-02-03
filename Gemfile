source 'https://rubygems.org'
ruby '2.1.2'

gem 'rails', '4.1.4'
gem 'actionpack-page_caching'
# gem 'mysql2'
gem 'mysql'
gem 'newrelic_rpm'
gem 'capistrano', '~> 2.15.5'

# precompiled assets
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.2'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

gem 'yui-rails' # Use yui as the JavaScript library
gem 'haml'
gem 'prototype-rails'
gem 'icalendar', '1.1.6'
gem 'dynamic_form' # providing error_messages_for
gem 'rake', '10.1.1'  # Gems requiring specific version
gem 'json'
gem 'json_pure', '1.7.4'
gem 'viewpoint', '0.1.27'
gem 'ckeditor'
gem 'rmagick', '2.13.2'
gem 'premailer-rails'
gem 'aasm', '4.0.8'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :asee do
  # ASEE gems
  gem 'asee_utilities', git: 'git@gitlab.asee.org:asee-it/asee-utilities.git'
  gem 'authenticated_system', git: 'git@gitlab.asee.org:asee-it/authenticated-system.git'
  gem 'file_column', git: 'https://github.com/asee/file_column.git'
  gem 'acts_as_versioned', :git => 'https://github.com/asee/acts_as_versioned.git'
  gem 'mixable_engines', git: 'https://github.com/asee/mixable_engines.git'
  gem 'calendar_date_select', :git => 'https://github.com/asee/calendar_date_select.git'
  gem 'make_resourceful', :git => 'https://github.com/asee/make_resourceful' # updated to not conflict with rails
  gem 'rtex', :git => 'https://github.com/asee/rtex'
  gem 'lp_select', :git => 'https://github.com/asee/lp_select', :branch => 'ruby-2x'
  gem 'massive_match', :git => 'https://github.com/asee/massive_match'


  # ASEE engines
  gem 'admin', git: 'git@gitlab.asee.org:asee-it/admin-engine.git'
  gem 'deploy', git: 'git@gitlab.asee.org:asee-it/deploy.git'
  gem 'apply', git: 'git@gitlab.asee.org:asee-it/apply-engine.git'
  gem 'cms', :git => 'git@gitlab.asee.org:asee-it/cms-engine.git'
  gem 'extranet', git: 'git@gitlab.asee.org:asee-it/extranet-engine.git'
  gem 'helpdesk', git: 'git@gitlab.asee.org:asee-it/helpdesk-engine.git'
  gem 'reporting', git: 'git@gitlab.asee.org:asee-it/reporting-engine.git'
end

group :development, :test do
  gem 'pry'
  gem 'pry-byebug'
  gem 'byebug'
end

group :production do
  gem 'therubyracer'
end

group :test do
  gem 'faker'
  gem 'shoulda', :require => false
  gem 'shoulda-matchers', :require => false
  gem 'shoulda-kept-assign-to'
  gem 'machinist', '~> 2.0'
  gem 'mocha', :require => false
end

