require 'rails_helper'
require 'swagger_helper'

describe 'Products API V1', type: :request do
  path '/api/v1/products' do
    get 'List all products' do
      tags 'Products'
      produces 'application/json'
      description 'Returns a list of all products'

      response '200', 'Success - returns list of products' do
        let!(:product) { Product.create!(name: 'iPhone 15', price: 999.99) }

        run_test!
      end
    end

    post 'Create a product' do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'
      description 'Creates a new product'

      parameter name: :product, in: :body, required: true, schema: {
        type: :object,
        properties: {
          product: {
            type: :object,
            properties: {
              name: { type: :string },
              description: { type: :string },
              price: { type: :number }
            }
          }
        }
      }

      response '201', 'Product created' do
        let(:product) { { product: { name: 'AirPods', price: 249.99 } } }
        run_test! do |response|
          # Skip body validation
        end
      end
    end
  end

  path '/api/v1/products/{id}' do
    parameter name: :id, in: :path, type: :integer, required: true

    get 'Get a product' do
      tags 'Products'
      produces 'application/json'
      description 'Returns a single product by ID'

      response '200', 'Product found' do
        let(:id) { Product.create!(name: 'iPad', price: 799.99).id }
        run_test!
      end

      response '404', 'Product not found' do
        let(:id) { 99999 }
        run_test!
      end
    end

    patch 'Update a product' do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'
      description 'Updates a product'

      parameter name: :product, in: :body, required: true, schema: {
        type: :object,
        properties: {
          product: {
            type: :object,
            properties: {
              name: { type: :string },
              price: { type: :number }
            }
          }
        }
      }

      response '200', 'Product updated' do
        let(:id) { Product.create!(name: 'MacBook', price: 1999.99).id }
        let(:product) { { product: { name: 'MacBook Pro' } } }
        run_test! do |response|
          # Skip body validation
        end
      end

      response '404', 'Product not found' do
        let(:id) { 99999 }
        let(:product) { { product: { name: 'Test' } } }
        run_test!
      end
    end

    delete 'Delete a product' do
      tags 'Products'
      description 'Deletes a product'

      response '204', 'Product deleted' do
        let(:id) { Product.create!(name: 'Delete Me', price: 50.00).id }
        run_test!
      end

      response '404', 'Product not found' do
        let(:id) { 99999 }
        run_test!
      end
    end
  end
end



