source 'https://rubygems.org'

ruby '2.0.0'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.3'


# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

# Support for React.js, and JSX in the asset pipeline
gem 'react-rails', '~> 1.0.0.pre', github: 'reactjs/react-rails'
gem "therubyracer", :platforms => :ruby

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

# Required for heroku
gem 'rails_12factor', group: :production

# MongoDB ODM
gem 'mongoid', git: 'https://github.com/mongoid/mongoid.git'

# Dota Web API
# gem 'dota', git: 'https://github.com/nashby/dota.git'
gem 'dota', git: 'https://github.com/ccblaisdell/dota.git', branch: "fix_match_with_no_upgrades"

# Set environment variables
gem "figaro"

# Work fetching and analysis in the background
gem "delayed_job_mongoid", git: 'https://github.com/collectiveidea/delayed_job_mongoid.git'
gem 'sucker_punch', '~> 1.0'

# Run Heroku workers only when needed
# gem "workless"

# Pagination
gem 'kaminari'

# AI, neural networks and genetic algorithms
gem "ai4r"

group :development do
  gem 'pry-rails'
  gem 'pry-remote'
  gem 'pry-stack_explorer'
end

group :test do
  gem 'simplecov'
  gem 'rails_best_practices'
  gem "factory_girl_rails", "~> 4.0"
  gem 'pry-rails'
  gem 'pry-stack_explorer'
end

group :production do
  # Use unicorn as the app server
  gem 'unicorn'
end