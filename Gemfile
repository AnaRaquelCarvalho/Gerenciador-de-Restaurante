source "https://rubygems.org"

gem "rails", "~> 8.1.1"
gem "propshaft"
gem "pg" # Banco de dados PostgreSQL
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "jbuilder"

# OBRIGATÓRIO para o Devise funcionar:
gem "bcrypt", "~> 3.1.7"

# Windows fixes
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "fiddle" # Importante para Ruby 3.4 no Windows

# Rails 8 Performance stack
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false
gem "image_processing", "~> 1.2"

# Funcionalidades do Projeto
gem "font-awesome-sass", "~> 6.5.1"
gem "devise", "~> 4.9"
gem "stripe"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "bundler-audit", require: false
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false

  # Movido para cá para carregar suas chaves do Stripe no ambiente de dev
  gem "dotenv-rails"
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
