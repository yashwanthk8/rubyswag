# Product API

A clean, production-oriented Ruby on Rails API-only application for managing products. Built with PostgreSQL, featuring comprehensive testing with RSpec and interactive API documentation with Swagger/OpenAPI.

## Features

- **RESTful API** with versioning (`/api/v1/`)
- **PostgreSQL** database integration
- **Complete CRUD** operations for products
- **Input validation** with meaningful error messages
- **Comprehensive test coverage** using RSpec
- **Interactive API documentation** with Swagger UI
- **OpenAPI 3.x** specification generation
- **Clean, beginner-friendly** code structure

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation](#installation)
3. [Configuration](#configuration)
4. [Database Setup](#database-setup)
5. [Running the Application](#running-the-application)
6. [Running Tests](#running-tests)
7. [API Documentation](#api-documentation)
8. [API Endpoints](#api-endpoints)
9. [Example Requests](#example-requests)
10. [Project Structure](#project-structure)
11. [Architecture](#architecture)

## Prerequisites

- Ruby 3.0 or higher
- PostgreSQL 12 or higher
- Bundler
- Rails 8.1+

### Verify Installation

```bash
ruby --version      # Should be 3.0 or higher
postgres --version  # Should be 12 or higher
bundle --version    # Should be available
```

## Installation

### 1. Clone/Navigate to the Project

```bash
cd product_api
```

### 2. Install Ruby Dependencies

```bash
bundle install
```

If you encounter issues with the `pg` gem on macOS, you may need to specify the PostgreSQL configuration:

```bash
bundle config set build.pg --with-pg-config=/opt/homebrew/bin/pg_config
bundle install
```

## Configuration

### 1. PostgreSQL Setup

Ensure PostgreSQL is running:

```bash
# macOS with Homebrew
brew services start postgresql

# Verify PostgreSQL is running
psql --version
```

### 2. Rails Configuration

The application is already configured as API-only with PostgreSQL. Key configuration files:

- `config/database.yml` - Database connection settings
- `config/application.rb` - API-only mode enabled
- `config/routes.rb` - API versioning and Rswag mounts

## Database Setup

### 1. Create the Database

```bash
bin/rails db:create
```

Expected output:
```
Created database 'product_api_development'
Created database 'product_api_test'
```

### 2. Run Migrations

```bash
bin/rails db:migrate
```

Expected output:
```
== 20260913043334 CreateProducts: migrating ===================================
-- create_table(:products)
   -> 0.0156s
== 20260913043334 CreateProducts: migrated (0.0156s) ==========================
```

### 3. (Optional) Seed Sample Data

```bash
bin/rails db:seed
```

Expected output:
```
Created product: iPhone 15
Created product: MacBook Pro 16"
Created product: AirPods Pro
✓ Seeding complete! 3 products created.
```

## Running the Application

### Start the Rails Server

```bash
bin/rails server
# or
rails s
```

The server will start on `http://localhost:3000`

```
=> Rails 8.1.2 application starting in development on http://localhost:3000
=> Run `bin/rails server --help` for more startup options
Puma starting in single mode...
* Puma version: X.X.X
* Min threads: 5, max threads: 5
* Environment: development
* Listening on http://127.0.0.1:3000
```

## Running Tests

### Run All Tests

```bash
bundle exec rspec
```

Expected output:
```
Products API V1
  GET /api/v1/products
    ✓ returns all products with 200 status
    ✓ returns empty array when no products exist
  GET /api/v1/products/:id
    ✓ returns the product with 200 status
    ✓ returns 404 for non-existent product
  POST /api/v1/products
    ✓ creates a product with valid parameters and returns 201
    ✓ returns 422 when name is missing
    ✓ returns 422 when price is missing
    ✓ returns 422 when price is not greater than 0
  PATCH /api/v1/products/:id
    ✓ updates the product and returns 200
    ✓ returns 404 for non-existent product
    ✓ returns 422 when validation fails
    ✓ partially updates fields
  DELETE /api/v1/products/:id
    ✓ deletes the product and returns 204
    ✓ returns 404 for non-existent product
    ✓ decreases product count

29 examples, 0 failures
```

### Run Specific Test File

```bash
bundle exec rspec spec/requests/api/v1/products_spec.rb
```

### Run with Detailed Output

```bash
bundle exec rspec --format documentation
```

## API Documentation

### View Swagger UI

1. **Start the Rails server:**
   ```bash
   bin/rails server
   ```

2. **Open your browser and navigate to:**
   ```
   http://localhost:3000/api-docs
   ```

You should see the Swagger UI displaying all available Product endpoints. You can:
- View request/response schemas
- See required parameters
- Try out endpoints with the "Try it out" button
- View example responses

### Generate OpenAPI Specification

To generate the OpenAPI YAML specification:

```bash
bin/rails rswag
```

The generated file will be located at:
```
openapi/v1/openapi.yaml
```

You can use this file to:
- Share API documentation with frontend teams
- Import into Postman or other API clients
- Generate client SDKs
- Integration with API gateways

## API Endpoints

All endpoints require JSON requests/responses. Base URL: `http://localhost:3000/api/v1`

### List All Products

**Request:**
```
GET /api/v1/products
```

**Response (200 OK):**
```json
[
  {
    "id": 1,
    "name": "iPhone 15",
    "description": "Latest generation iPhone",
    "price": "999.99",
    "created_at": "2025-01-15T10:30:00Z",
    "updated_at": "2025-01-15T10:30:00Z"
  }
]
```

### Get a Single Product

**Request:**
```
GET /api/v1/products/:id
```

**Response (200 OK):**
```json
{
  "id": 1,
  "name": "iPhone 15",
  "description": "Latest generation iPhone",
  "price": "999.99",
  "created_at": "2025-01-15T10:30:00Z",
  "updated_at": "2025-01-15T10:30:00Z"
}
```

**Response (404 Not Found):**
```json
{
  "errors": ["Record not found"]
}
```

### Create a Product

**Request:**
```
POST /api/v1/products
Content-Type: application/json

{
  "product": {
    "name": "MacBook Pro",
    "description": "Powerful laptop",
    "price": 1999.99
  }
}
```

**Response (201 Created):**
```json
{
  "id": 2,
  "name": "MacBook Pro",
  "description": "Powerful laptop",
  "price": "1999.99",
  "created_at": "2025-01-15T10:35:00Z",
  "updated_at": "2025-01-15T10:35:00Z"
}
```

**Response (422 Unprocessable Entity):**
```json
{
  "errors": [
    "Name can't be blank",
    "Price can't be blank"
  ]
}
```

### Update a Product

**Request:**
```
PATCH /api/v1/products/:id
Content-Type: application/json

{
  "product": {
    "name": "MacBook Pro M4",
    "price": 2499.99
  }
}
```

**Response (200 OK):**
```json
{
  "id": 2,
  "name": "MacBook Pro M4",
  "description": "Powerful laptop",
  "price": "2499.99",
  "created_at": "2025-01-15T10:35:00Z",
  "updated_at": "2025-01-15T10:40:00Z"
}
```

### Delete a Product

**Request:**
```
DELETE /api/v1/products/:id
```

**Response (204 No Content):**
```
[empty body]
```

## Example Requests

### Using cURL

#### List all products
```bash
curl -X GET http://localhost:3000/api/v1/products
```

#### Get a specific product
```bash
curl -X GET http://localhost:3000/api/v1/products/1
```

#### Create a product
```bash
curl -X POST http://localhost:3000/api/v1/products \
  -H "Content-Type: application/json" \
  -d '{
    "product": {
      "name": "iPad Air",
      "description": "Premium tablet",
      "price": 799.99
    }
  }'
```

#### Update a product
```bash
curl -X PATCH http://localhost:3000/api/v1/products/1 \
  -H "Content-Type: application/json" \
  -d '{
    "product": {
      "name": "iPhone 15 Pro",
      "price": 1099.99
    }
  }'
```

#### Delete a product
```bash
curl -X DELETE http://localhost:3000/api/v1/products/1
```

### Using HTTPie

```bash
# List products
http GET localhost:3000/api/v1/products

# Create product
http POST localhost:3000/api/v1/products \
  name="Apple Watch" \
  description="Smart watch" \
  price:=399.99

# Update product
http PATCH localhost:3000/api/v1/products/1 \
  name="Apple Watch Series 10"

# Delete product
http DELETE localhost:3000/api/v1/products/1
```

### Using Postman

1. Import the generated OpenAPI spec: `openapi/v1/openapi.yaml`
2. Postman will automatically create collections with all endpoints
3. You can then test each endpoint with pre-filled request templates

## Project Structure

```
product_api/
├── app/
│   ├── controllers/
│   │   ├── api/
│   │   │   └── v1/
│   │   │       └── products_controller.rb  # API endpoints
│   │   └── application_controller.rb       # Error handling
│   ├── models/
│   │   └── product.rb                      # Product model with validations
│   └── ...
├── config/
│   ├── routes.rb                           # API routes and versioning
│   ├── database.yml                        # Database configuration
│   ├── application.rb                      # Rails configuration
│   └── ...
├── db/
│   ├── migrate/
│   │   └── 20260913043334_create_products.rb
│   ├── seeds.rb                            # Sample data
│   └── schema.rb                           # Database schema
├── spec/
│   ├── rails_helper.rb                     # RSpec configuration
│   ├── swagger_helper.rb                   # Rswag configuration
│   ├── requests/
│   │   └── api/v1/
│   │       └── products_spec.rb            # Request tests
│   └── integration/
│       └── api_v1_products_spec.rb         # Swagger specs
├── openapi/
│   └── v1/
│       └── openapi.yaml                    # Generated OpenAPI spec
├── Gemfile                                 # Ruby dependencies
├── Rakefile                                # Rails tasks
└── README.md                               # This file
```

## Architecture

### Request Flow

```
Client Request (e.g., POST /api/v1/products)
        ↓
config/routes.rb (Routing)
        ↓
app/controllers/api/v1/products_controller.rb (ProductsController)
        ↓
Strong Parameters Validation (product_params)
        ↓
app/models/product.rb (Product Model)
        ↓
Model Validations (presence, numericality)
        ↓
PostgreSQL Database
        ↓
JSON Response (via render json:)
        ↓
Client Response (e.g., 201 Created)
```

### Key Components

#### 1. **Routing** (`config/routes.rb`)
- API versioning with `namespace :api` and `namespace :v1`
- RESTful resources for products
- Rswag UI and API endpoints mounted at `/api-docs`

#### 2. **Controller** (`app/controllers/api/v1/products_controller.rb`)
- Handles HTTP requests and responses
- Uses strong parameters to whitelist allowed attributes
- Returns appropriate HTTP status codes
- Handles validation errors

#### 3. **Model** (`app/models/product.rb`)
- Defines product attributes and relationships
- Implements business logic validations:
  - Name is required
  - Price is required and must be > 0
- Communicates with database through ActiveRecord

#### 4. **Error Handling** (`app/controllers/application_controller.rb`)
- Rescues `ActiveRecord::RecordNotFound` exceptions
- Returns consistent error JSON response with 404 status

#### 5. **Testing** (`spec/`)
- **Request specs**: Test API endpoints and HTTP interactions
- **Integration specs**: Generate Swagger documentation while testing
- Uses transactional fixtures for test isolation

#### 6. **API Documentation** (`spec/swagger_helper.rb`)
- Rswag configuration for OpenAPI 3.0.1
- Product schema with all properties and types
- Server configuration for Swagger UI
- Error schema for consistent error responses

### Response Format

All responses are JSON. Successful responses include resource data:
```json
{
  "id": 1,
  "name": "Product Name",
  "description": "Description",
  "price": "99.99",
  "created_at": "2025-01-15T10:30:00Z",
  "updated_at": "2025-01-15T10:30:00Z"
}
```

Error responses follow a consistent format:
```json
{
  "errors": ["Error message 1", "Error message 2"]
}
```

### HTTP Status Codes

| Code | Meaning | When Used |
|------|---------|-----------|
| 200 | OK | Successful GET or PATCH request |
| 201 | Created | Successful POST request |
| 204 | No Content | Successful DELETE request |
| 404 | Not Found | Resource doesn't exist |
| 422 | Unprocessable Entity | Validation errors |

## Development Tips

### Viewing Database

```bash
# Open Rails console
bin/rails console

# Query products
Product.all
Product.find(1)
Product.first
```

### Checking Routes

```bash
bin/rails routes
```

### Running a Single Test

```bash
bundle exec rspec spec/requests/api/v1/products_spec.rb -e "creates a product"
```

### Debugging Requests

Add debugging to your controller:
```ruby
def create
  Rails.logger.info("Params: #{product_params.inspect}")
  # ... rest of code
end
```

View logs:
```bash
tail -f log/development.log
```

## Troubleshooting

### PostgreSQL Connection Error

```
could not connect to server: No such file or directory
```

**Solution:**
```bash
# Start PostgreSQL
brew services start postgresql

# Check status
brew services list
```

### Gem Installation Failed

```
Gem::Installer::ExtensionBuildError: ERROR: Failed to build gem native extension
```

**Solution:**
```bash
# For macOS, may need PostgreSQL config
bundle config set build.pg --with-pg-config=/opt/homebrew/bin/pg_config
bundle install
```

### Tests Fail with Database Error

```bash
# Reset database
bin/rails db:drop db:create db:migrate

# Or for tests
RAILS_ENV=test bin/rails db:drop db:create db:migrate
```

### OpenAPI Generation Issues

```bash
# Ensure Rswag is properly configured
bundle exec rswag

# Check openapi/v1/ directory was created
ls -la openapi/v1/openapi.yaml
```

## Production Deployment

When deploying to production:

1. **Set environment variables:**
   ```bash
   export RAILS_ENV=production
   export DATABASE_URL="postgres://user:pass@host:5432/product_api_prod"
   export SECRET_KEY_BASE="your-secret-key"
   ```

2. **Prepare database:**
   ```bash
   bin/rails db:create db:migrate
   bin/rails db:seed  # Optional
   ```

3. **Start the application:**
   ```bash
   bin/rails server -b 0.0.0.0
   ```

4. **For containerized deployment, see [Dockerfile](./Dockerfile)**

## Version Notes

- **Rails**: 8.1.2
- **Ruby**: 3.0+
- **PostgreSQL**: 12+
- **Rswag**: Latest (for OpenAPI 3.x support)
- **RSpec Rails**: Latest

This ensures compatibility with modern Rails conventions and best practices.

## License

This project is provided as-is for educational and development purposes.

