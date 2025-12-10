# F1 API - Security Configuration

## 🔐 Authentication Status

### Protected Endpoints (Require JWT Token)

All CRUD operations now require authentication via JWT token:

#### Drivers API ✅
```ruby
class Api::V1::DriversController < ApplicationController
  before_action :authenticate_user! # ✅ ENABLED
```
- GET /api/v1/drivers
- POST /api/v1/drivers
- GET /api/v1/drivers/:id
- PATCH /api/v1/drivers/:id
- DELETE /api/v1/drivers/:id

#### Circuits API ✅
```ruby
class Api::V1::CircuitsController < ApplicationController
  before_action :authenticate_user! # ✅ ENABLED
```
- GET /api/v1/circuits
- POST /api/v1/circuits
- GET /api/v1/circuits/:id
- PATCH /api/v1/circuits/:id
- DELETE /api/v1/circuits/:id

#### Lap Times API ✅
```ruby
class Api::V1::LapTimesController < ApplicationController
  before_action :authenticate_user! # ✅ ENABLED
```
- GET /api/v1/lap_times
- POST /api/v1/lap_times
- GET /api/v1/lap_times/:id
- PATCH /api/v1/lap_times/:id
- DELETE /api/v1/lap_times/:id
- GET /api/v1/lap_times/fastest

#### Standings API ✅
```ruby
class Api::V1::StandingsController < ApplicationController
  before_action :authenticate_user! # ✅ ENABLED
```
- GET /api/v1/standings

### Public Endpoints (No Authentication Required)

#### Health Check 
```ruby
class Api::V1::HealthController < ApplicationController
  # No authentication - allows monitoring tools to check API status
```
- GET /api/v1/health

**Rationale**: Health checks should be publicly accessible for monitoring and load balancer health checks.

#### Authentication Endpoints
```ruby
# No authentication required (by design)
```
- POST /api/v1/auth/register - Register new user
- POST /api/v1/auth/login - Login and receive JWT token

**Note**: Logout requires authentication to revoke the token.

---

## 🔑 How Authentication Works

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

**Response Headers:**
```
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...
```

**Response Body:**
```json
{
  "message": "Welcome, you're in",
  "user": {
    "id": 1,
    "email": "user@example.com"
  }
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

---

## 🛡️ Security Features Implemented

### 1. JWT Authentication ✅
- Token-based authentication using devise-jwt
- Tokens expire after 24 hours
- Secure token generation using Rails secret_key_base

### 2. Token Revocation ✅
- JwtDenylist model tracks revoked tokens
- Logout properly revokes tokens
- Prevents reuse of old tokens

### 3. Password Security ✅
- Bcrypt password hashing (via Devise)
- Password confirmation required on registration
- Secure password reset flow available

### 4. CORS Configuration ✅
- rack-cors gem installed
- Configure allowed origins in `config/initializers/cors.rb`

### 5. API Versioning ✅
- All endpoints under `/api/v1/`
- Easy to add v2, v3 in future without breaking existing clients

---

## 📋 Testing Authenticated Endpoints

### Update Your Tests

Since authentication is now required, update your RSpec tests to include authentication:

```ruby
# spec/support/auth_helpers.rb
module AuthHelpers
  def auth_headers(user)
    post "/api/v1/auth/login", params: { 
      user: { email: user.email, password: user.password } 
    }
    token = response.headers['Authorization']
    { 'Authorization' => token }
  end
end

RSpec.configure do |config|
  config.include AuthHelpers, type: :request
end

# In your tests:
RSpec.describe 'Drivers API', type: :request do
  let(:user) { User.create!(email: 'test@example.com', password: '123456') }
  let(:headers) { auth_headers(user) }
  
  it 'returns drivers' do
    get '/api/v1/drivers', headers: headers
    expect(response).to have_http_status(200)
  end
end
```

---

## 🔒 Additional Security Recommendations

### 1. Rate Limiting
Consider adding rate limiting to prevent abuse:

```ruby
# Gemfile
gem 'rack-attack'

# config/initializers/rack_attack.rb
Rack::Attack.throttle('api/ip', limit: 100, period: 1.minute) do |req|
  req.ip if req.path.start_with?('/api/')
end
```

### 2. Role-Based Access Control (RBAC)
Add user roles if needed:

```ruby
# Add role column to users table
rails g migration AddRoleToUsers role:string

# In User model
enum role: { user: 'user', admin: 'admin' }

# In controllers
def require_admin
  render json: { error: 'Unauthorized' }, status: :forbidden unless current_user.admin?
end
```

### 3. Read-Only Endpoints for Public Access
If you want some endpoints public (read-only) but others protected:

```ruby
class Api::V1::DriversController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  # GET requests public, POST/PATCH/DELETE require auth
```

### 4. API Key Authentication (Alternative)
For machine-to-machine communication:

```ruby
# Add api_key to users table
# Validate API key in ApplicationController
def authenticate_api_key
  api_key = request.headers['X-API-Key']
  @current_user = User.find_by(api_key: api_key)
  render json: { error: 'Invalid API Key' }, status: :unauthorized unless @current_user
end
```

---

## 🧪 Test Authentication

### 1. Without Token (Should Fail)
```bash
curl -X GET http://localhost:3000/api/v1/drivers
# Expected: 401 Unauthorized
```

### 2. With Valid Token (Should Work)
```bash
# First, login and save the token
TOKEN=$(curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"user":{"email":"test@test.com","password":"123456"}}' \
  -i | grep Authorization | cut -d' ' -f2-)

# Then use the token
curl -X GET http://localhost:3000/api/v1/drivers \
  -H "Authorization: Bearer $TOKEN"
# Expected: 200 OK with driver data
```

---

## 📊 Current Security Status

| Feature | Status | Details |
|---------|--------|---------|
| JWT Authentication | ✅ Enabled | All CRUD endpoints protected |
| Token Revocation | ✅ Enabled | JwtDenylist tracking |
| Password Hashing | ✅ Enabled | Bcrypt via Devise |
| HTTPS Ready | ⚠️ Configure | Set up SSL in production |
| Rate Limiting | ⏳ Recommended | Add rack-attack |
| CORS | ✅ Configured | rack-cors installed |
| API Versioning | ✅ Enabled | All under /api/v1 |
| Input Validation | ✅ Enabled | Strong parameters |

---

## 🚨 Important Notes

1. **Never commit secrets**: Keep your `config/master.key` and credentials secure
2. **Use HTTPS in production**: Always use SSL/TLS for API requests in production
3. **Rotate secrets regularly**: Change JWT secrets periodically
4. **Monitor failed login attempts**: Implement logging for security events
5. **Keep gems updated**: Regularly run `bundle update` for security patches

---

## 📝 Environment Variables

For production, use environment variables for sensitive data:

```bash
# .env (don't commit this!)
JWT_SECRET_KEY=your_super_secret_key_here
DATABASE_URL=postgresql://...
RAILS_MASTER_KEY=your_master_key_here
```

```ruby
# config/initializers/devise.rb
config.jwt do |jwt|
  jwt.secret = ENV['JWT_SECRET_KEY'] || Rails.application.credentials.secret_key_base
  # ...
end
```

---

## ✅ Security Checklist

- [x] JWT authentication enabled on all CRUD endpoints
- [x] Password hashing with bcrypt
- [x] Token revocation system
- [x] CORS configured
- [x] API versioning
- [x] Strong parameters
- [ ] Rate limiting (recommended)
- [ ] HTTPS in production (required)
- [ ] Security headers (recommended)
- [ ] Input sanitization (recommended)
- [ ] SQL injection prevention (Rails handles this)

Your API now has a solid security foundation! 🔒

