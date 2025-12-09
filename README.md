# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization
rails db:create
rails db:migrate


* How to run the test suite
rails generate rspec:install

* Generate swagger docs
bundle exec rspec
bundle exec rake rswag:specs:swaggerize

Then visit:
http://localhost:3000/api-docs



* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
