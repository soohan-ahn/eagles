source "https://rubygems.org"


# Bundle edge Rails instead: gem "rails", github: "rails/rails"
gem "rails", "4.2.2"
gem "mysql2"
gem "sass-rails", "~> 5.0"
gem "uglifier", ">= 1.3.0"
gem "coffee-rails", "~> 4.1.0"
gem "jquery-rails"
gem "turbolinks"
gem "jbuilder", "~> 2.0"
gem "sdoc", "~> 0.4.0", group: :doc
gem "bcrypt"
gem "rails_12factor", group: :production

gem "config"
gem "slim"
gem "pry-rails"

gem "therubyracer"
gem "less-rails"
gem "twitter-bootstrap-rails"

gem "net-ssh"
gem "unicorn"

%w[rspec rspec-core rspec-expectations rspec-mocks rspec-rails rspec-support].each do |lib|
  gem lib, :git => "git://github.com/rspec/#{lib}.git", branch: 'master'
end

# Use ActiveModel has_secure_password
# gem "bcrypt", "~> 3.1.7"

# Use Unicorn as the app server
# gem "unicorn"

# Use Capistrano for deployment
# gem "capistrano-rails", group: :development

group :development, :test, :production do
  gem "byebug"
  gem "web-console", "~> 2.0", group: :development
  gem "spring"
  gem 'capistrano'
  gem 'capistrano-rails', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rvm'
  gem 'capistrano3-unicorn'
  gem 'capistrano3-nginx', '~> 2.0'
end

