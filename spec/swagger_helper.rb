RSpec.configure do |config|

  config.openapi_root = Rails.root.join("openapi").to_s

  config.openapi_specs = {
    "v1/swagger.yaml" => {
      openapi: "3.0.1",

      info: {
        title: "Product API",
        version: "v1",
        description: "A simple REST API for managing products"
      },

      servers: [
        {
          url: "http://localhost:3000",
          description: "Development server"
        }
      ],

      paths: {},

      components: {
        schemas: {
          Product: {
            type: :object,
            properties: {
              id: {
                type: :integer,
                description: "The product ID"
              },
              name: {
                type: :string,
                description: "The product name"
              },
              description: {
                type: :string,
                nullable: true,
                description: "The product description"
              },
              price: {
                type: :string,
                format: "decimal",
                description: "The product price (must be greater than 0)"
              },
              created_at: {
                type: :string,
                format: "date-time",
                description: "When the product was created"
              },
              updated_at: {
                type: :string,
                format: "date-time",
                description: "When the product was last updated"
              }
            },
            required: [
              "id",
              "name",
              "price",
              "created_at",
              "updated_at"
            ]
          },
          Error: {
            type: :object,
            properties: {
              errors: {
                type: :array,
                items: { type: :string }
              }
            }
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml or json in urls.
  # Defaults to nil.
  config.swagger_format = :yaml
end
