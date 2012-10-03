source 'http://rubygems.org'

gem 'rails', '3.1.3'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'
#gem 'devise'

gem 'mysql2'
gem 'nokogiri'
gem 'haml'
gem 'redis'
gem 'loginza'
gem 'ultraviolet'
gem 'pry'
gem 'pry-nav'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.1.5'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'haml-rails'
gem 'twitter-bootstrap-rails'

group :test do
  # Pretty printed test output
  gem 'turn', '~> 0.8.3', :require => false
  gem "factory_girl", "~> 2.6.0"
  gem 'guard-rspec', :platforms => :ruby # Unix only
  gem "fakeweb"
end

group :development do
  gem 'mongrel', :platforms => :ruby , :require => false
end

gem "rspec", "2.7", :group => [:development, :test]
gem "rspec-rails", "2.7", :group => [:development, :test]
