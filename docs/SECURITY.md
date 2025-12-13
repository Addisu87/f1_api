# Security & Authentication

## Overview

The F1 API uses JWT (JSON Web Token) authentication via Devise JWT. All protected endpoints require a valid Bearer token in the Authorization header.

## Authentication Flow

### 1. Register a User
```bash
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "user": {
      "email": "user@example.com",
      "password": "password123",
      "password_confirmation": "password123"
    }
  }'
```

**Response:**
```json
{
  "message": "You've registered successfully",
  "user": {
    "id": 1,
    "email": "user@example.com"
  }
}
```

### 2. Login to Get JWT Token
```bash
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "user": {
      "email": "user@example.com",
      "password": "password123"
    }
  }'
```

**Response:**
```json
{
  "message": "Welcome, you're in",
  "user": {
    "id": 1,
    "email": "user@example.com"
  },
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "token_type": "Bearer"
}
```

### 3. Use JWT Token in Requests
```bash
curl -X GET http://localhost:3000/api/v1/drivers \
  -H "Authorization: Bearer YOUR_JWT_TOKEN_HERE" \
  -H "Content-Type: application/json"
```

### 4. Logout (Revoke Token)
```bash
curl -X DELETE http://localhost:3000/api/v1/auth/logout \
  -H "Authorization: Bearer YOUR_JWT_TOKEN_HERE" \
  -H "Content-Type: application/json"
```

## Security Features

### JWT Configuration
- **Token Expiration**: 30 minutes
- **Secret Key**: Uses Rails `secret_key_base`
- **Revocation Strategy**: JwtDenylist model tracks revoked tokens

### Password Security
- **Hashing**: BCrypt via Devise
- **Minimum Length**: 6 characters
- **Confirmation**: Required on registration

### Protected Endpoints
All CRUD operations require authentication:
- Drivers API
- Circuits API
- Lap Times API
- Standings API

### Public Endpoints
- `GET /api/v1/health` - Health check (no auth required)
- `POST /api/v1/auth/register` - Registration (no auth required)
- `POST /api/v1/auth/login` - Login (no auth required)

## Security Best Practices

1. **Never commit secrets** - Keep `config/master.key` and credentials secure
2. **Use HTTPS in production** - Always use SSL/TLS for API requests
3. **Rotate secrets regularly** - Change JWT secrets periodically
4. **Monitor failed login attempts** - Implement logging for security events
5. **Keep gems updated** - Regularly run `bundle update` for security patches

## Testing Authentication

### Without Token (Should Fail)
```bash
curl -X GET http://localhost:3000/api/v1/drivers
# Expected: 401 Unauthorized
```

### With Valid Token (Should Work)
```bash
# Login and save token
TOKEN=$(curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"user":{"email":"test@test.com","password":"123456"}}' \
  -s | jq -r '.token')

# Use token
curl -X GET http://localhost:3000/api/v1/drivers \
  -H "Authorization: Bearer $TOKEN"
# Expected: 200 OK with driver data
```

## Configuration

JWT configuration is in `config/initializers/devise.rb`:

```ruby
config.jwt do |jwt|
  jwt.secret = Rails.application.credentials.secret_key_base
  jwt.dispatch_requests = [['POST', %r{^/api/v1/auth/login$}]]
  jwt.revocation_requests = [['DELETE', %r{^/api/v1/auth/logout$}]]
  jwt.expiration_time = 30.minutes.to_i
end
```
