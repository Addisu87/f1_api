# 🏁 F1 API

A RESTful API for Formula 1 lap time data and analytics, built with Ruby on Rails 8.1.

## 🚀 Quick Start

### Prerequisites
- Ruby 3.3+
- PostgreSQL
- Rails 8.1

### Setup
```bash
# Install dependencies
bundle install

# Setup database
rails db:create
rails db:migrate
rails db:seed

# Start server
rails server
```

### Access API Documentation
```
http://localhost:3000/api-docs
```

## 📚 API Endpoints

### Authentication
- `POST /api/v1/auth/register` - Register new user
- `POST /api/v1/auth/login` - Login and get JWT token
- `DELETE /api/v1/auth/logout` - Logout (requires token)

### Protected Endpoints (Require JWT Token)
- `GET /api/v1/drivers` - List drivers
- `POST /api/v1/drivers` - Create driver
- `GET /api/v1/drivers/:id` - Show driver
- `PATCH /api/v1/drivers/:id` - Update driver
- `DELETE /api/v1/drivers/:id` - Delete driver

- `GET /api/v1/circuits` - List circuits
- `POST /api/v1/circuits` - Create circuit
- `GET /api/v1/circuits/:id` - Show circuit
- `PATCH /api/v1/circuits/:id` - Update circuit
- `DELETE /api/v1/circuits/:id` - Delete circuit

- `GET /api/v1/lap_times` - List lap times
- `POST /api/v1/lap_times` - Create lap time
- `GET /api/v1/lap_times/:id` - Show lap time
- `PATCH /api/v1/lap_times/:id` - Update lap time
- `DELETE /api/v1/lap_times/:id` - Delete lap time
- `GET /api/v1/lap_times/fastest` - Get fastest lap

- `GET /api/v1/standings` - Driver standings

### Public Endpoints
- `GET /api/v1/health` - Health check

## 🔐 Authentication

All protected endpoints require a JWT token in the Authorization header:

```bash
curl -X GET http://localhost:3000/api/v1/drivers \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

See [docs/SECURITY.md](docs/SECURITY.md) for detailed authentication guide.

## 🧪 Testing

```bash
# Run all tests
bundle exec rspec

# Generate Swagger documentation
bundle exec rake rswag:specs:swaggerize
```

## 🛠️ Development

### Database
```bash
rails db:create
rails db:migrate
rails db:seed
rails db:drop
```

### Console
```bash
rails console
```

### Routes
```bash
rails routes
```

### Stop Server
```bash
pkill -9 -f "puma.*f1_api"
```

# Build and start services
```bash
docker-compose up --build
```

# Run in background
```bash
docker-compose up -d
```

# View logs
```bash
docker-compose logs -f web
```

# Run Rails commands
```bash
docker-compose exec web rails console
docker-compose exec web rails db:migrate
```

# Stop services
```bash
docker-compose down
```

# Stop and remove volumes (clean slate)
```bash
docker-compose down -v
```

## 📖 Documentation

- [API Reference](docs/API.md) - Complete API endpoint documentation
- [Security Guide](docs/SECURITY.md) - Authentication and security details
- [Testing Guide](docs/TESTING.md) - Testing information

## 🏗️ Architecture

- **Framework**: Ruby on Rails 8.1 (API-only)
- **Authentication**: Devise + JWT
- **Documentation**: Rswag (Swagger/OpenAPI)
- **Database**: PostgreSQL
- **Serializers**: Active Model Serializers

## 📝 License

MIT
