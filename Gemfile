source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'activeresource', github: 'rails/activeresource'
gem 'active_model_serializers'
gem 'bcrypt', '~> 3.1.7'
gem 'has_scope'
gem 'jwt'
gem 'kaminari'
gem 'money-rails', '~>1'
gem 'pg'
gem 'puma', '~> 3.0'
gem 'pundit'
gem 'rails', '~> 5.0.1'
gem 'redis-rails'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  gem 'byebug', platform: :mri
end

group :test do
  gem 'factory_girl_rails', '~> 4.0'
  gem 'm'
  gem 'timecop'
end

group :development do
  gem 'listen', '~> 3.0.5'
end
