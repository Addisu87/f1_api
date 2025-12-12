# API Reference

## Base URL
```
http://localhost:3000/api/v1
```

## Authentication

All protected endpoints require JWT authentication. Include the token in the Authorization header:
```
Authorization: Bearer <your_jwt_token>
```

## Endpoints

### Drivers

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/drivers` | List all drivers | ✅ |
| POST | `/drivers` | Create driver | ✅ |
| GET | `/drivers/:id` | Show driver | ✅ |
| PATCH | `/drivers/:id` | Update driver | ✅ |
| DELETE | `/drivers/:id` | Delete driver | ✅ |

### Circuits

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/circuits` | List all circuits | ✅ |
| POST | `/circuits` | Create circuit | ✅ |
| GET | `/circuits/:id` | Show circuit | ✅ |
| PATCH | `/circuits/:id` | Update circuit | ✅ |
| DELETE | `/circuits/:id` | Delete circuit | ✅ |

### Lap Times

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/lap_times` | List lap times | ✅ |
| POST | `/lap_times` | Create lap time | ✅ |
| GET | `/lap_times/:id` | Show lap time | ✅ |
| PATCH | `/lap_times/:id` | Update lap time | ✅ |
| DELETE | `/lap_times/:id` | Delete lap time | ✅ |
| GET | `/lap_times/fastest` | Get fastest lap | ✅ |

### Standings

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/standings` | Driver standings | ✅ |

### Health

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/health` | Health check | ❌ |

## Request/Response Format

All requests and responses use JSON format.

### Example Request
```bash
curl -X POST http://localhost:3000/api/v1/drivers \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "driver": {
      "name": "Lewis Hamilton",
      "code": "HAM",
      "team": "Mercedes",
      "country": "United Kingdom"
    }
  }'
```

### Example Response
```json
{
  "id": 1,
  "name": "Lewis Hamilton",
  "code": "HAM",
  "team": "Mercedes",
  "country": "United Kingdom",
  "created_at": "2025-12-11T12:04:33.781Z",
  "updated_at": "2025-12-11T12:04:33.781Z"
}
```

## Error Responses

### 401 Unauthorized
```json
{
  "error": "Unauthorized",
  "message": "Missing or invalid authentication token"
}
```

### 422 Unprocessable Entity
```json
{
  "errors": {
    "name": ["can't be blank"],
    "code": ["can't be blank"]
  }
}
```

## Interactive Documentation

For interactive API documentation with request/response examples, visit:
```
http://localhost:3000/api-docs
```
