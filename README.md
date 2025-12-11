# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version

- System dependencies

- Configuration

- Database creation
  rails db:create

- Database initialization
  bin/rails db:migrate
  bin/rails db:seed
  rails db:drop

bundle exec rails db:migrate

psql -U postgres -d formula1db

- How to run the test suite
  rails generate rspec:install

- Generate swagger docs
  rails generate rspec:swagger API::MyController
  rails generate rspec:swagger Api::V1::LapTimesController --spec_path integration
  bundle exec rspec
  bundle exec rake rswag:specs:swaggerize

Then visit:
http://localhost:3000/api-docs

- start your app
  bin/rails server

- to debug your app
  rails console

* to check routes
  rails routes

ps aux | grep puma | grep f1_api
pkill -9 -f "puma.\*f1_api"

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...
