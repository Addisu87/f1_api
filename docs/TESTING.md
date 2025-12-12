# Testing Guide

## Running Tests

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/requests/api/v1/drivers_spec.rb

# Run with documentation format
bundle exec rspec --format documentation
```

## Test Coverage

### Request Specs
- ✅ Drivers API - All CRUD operations
- ✅ Circuits API - All CRUD operations
- ✅ Lap Times API - All CRUD operations
- ✅ Standings API - Standings calculation
- ✅ Health API - Health check endpoint
- ✅ Users API - Authentication endpoints

### Model Specs
- ✅ Driver model validations and associations
- ✅ Circuit model validations and associations
- ✅ LapTime model validations and associations
- ✅ User model Devise configuration
- ✅ JwtDenylist model

## Authentication in Tests

Tests use the `AuthHelper` module to generate JWT tokens:

```ruby
let(:user) { User.create!(email: 'test@example.com', password: '123456') }
let(:token) { generate_jwt_token(user) }
let(:Authorization) { "Bearer #{token}" }
```

## Generating Swagger Documentation

```bash
# Generate/update Swagger docs from specs
bundle exec rake rswag:specs:swaggerize
```

This generates `swagger/v1/swagger.yaml` which is served at `/api-docs`.

## Test Structure

```
spec/
├── requests/
│   └── api/v1/
│       ├── drivers_spec.rb
│       ├── circuits_spec.rb
│       ├── lap_times_spec.rb
│       ├── standings_spec.rb
│       ├── health_spec.rb
│       └── users_spec.rb
├── models/
│   ├── driver_spec.rb
│   ├── circuit_spec.rb
│   ├── lap_time_spec.rb
│   ├── user_spec.rb
│   └── jwt_denylist_spec.rb
└── support/
    └── auth_helper.rb
```
