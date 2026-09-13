require 'rails_helper'

RSpec.describe '/api/v1/products', type: :request do
  let!(:product) { Product.create!(name: 'iPhone 15', description: 'Latest iPhone', price: 999.99) }

  describe 'GET /api/v1/products' do
    it 'returns all products with 200 status' do
      get '/api/v1/products'
      
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')
      
      json_response = JSON.parse(response.body)
      expect(json_response).to be_an(Array)
      expect(json_response.length).to eq(1)
      expect(json_response[0]['name']).to eq('iPhone 15')
    end

    it 'returns empty array when no products exist' do
      Product.destroy_all
      
      get '/api/v1/products'
      
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response).to be_an(Array)
      expect(json_response.length).to eq(0)
    end
  end

  describe 'GET /api/v1/products/:id' do
    it 'returns the product with 200 status' do
      get "/api/v1/products/#{product.id}"
      
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')
      
      json_response = JSON.parse(response.body)
      expect(json_response['id']).to eq(product.id)
      expect(json_response['name']).to eq('iPhone 15')
      expect(json_response['price']).to eq('999.99')
    end

    it 'returns 404 for non-existent product' do
      get '/api/v1/products/99999'
      
      expect(response).to have_http_status(:not_found)
      
      json_response = JSON.parse(response.body)
      expect(json_response).to have_key('errors')
    end
  end

  describe 'POST /api/v1/products' do
    it 'creates a product with valid parameters and returns 201' do
      product_params = {
        product: {
          name: 'MacBook Pro',
          description: 'Powerful laptop',
          price: 1999.99
        }
      }
      
      post '/api/v1/products', params: product_params
      
      expect(response).to have_http_status(:created)
      expect(response.content_type).to include('application/json')
      
      json_response = JSON.parse(response.body)
      expect(json_response['name']).to eq('MacBook Pro')
      expect(json_response['price']).to eq('1999.99')
      expect(Product.count).to eq(2)
    end

    it 'returns 422 when name is missing' do
      product_params = {
        product: {
          description: 'Powerful laptop',
          price: 1999.99
        }
      }
      
      post '/api/v1/products', params: product_params
      
      expect(response).to have_http_status(:unprocessable_entity)
      
      json_response = JSON.parse(response.body)
      expect(json_response).to have_key('errors')
      expect(json_response['errors']).to be_an(Array)
      expect(json_response['errors'].join).to include("Name can't be blank")
    end

    it 'returns 422 when price is missing' do
      product_params = {
        product: {
          name: 'MacBook Pro',
          description: 'Powerful laptop'
        }
      }
      
      post '/api/v1/products', params: product_params
      
      expect(response).to have_http_status(:unprocessable_entity)
      
      json_response = JSON.parse(response.body)
      expect(json_response).to have_key('errors')
      expect(json_response['errors'].join).to include("Price can't be blank")
    end

    it 'returns 422 when price is not greater than 0' do
      product_params = {
        product: {
          name: 'MacBook Pro',
          description: 'Powerful laptop',
          price: -100.00
        }
      }
      
      post '/api/v1/products', params: product_params
      
      expect(response).to have_http_status(:unprocessable_entity)
      
      json_response = JSON.parse(response.body)
      expect(json_response).to have_key('errors')
      expect(json_response['errors'].join).to include('greater than 0')
    end

    it 'returns 422 when price is 0' do
      product_params = {
        product: {
          name: 'MacBook Pro',
          price: 0
        }
      }
      
      post '/api/v1/products', params: product_params
      
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PATCH /api/v1/products/:id' do
    it 'updates the product and returns 200' do
      update_params = {
        product: {
          name: 'iPhone 16',
          price: 1099.99
        }
      }
      
      patch "/api/v1/products/#{product.id}", params: update_params
      
      expect(response).to have_http_status(:ok)
      
      json_response = JSON.parse(response.body)
      expect(json_response['name']).to eq('iPhone 16')
      expect(json_response['price']).to eq('1099.99')
      
      product.reload
      expect(product.name).to eq('iPhone 16')
    end

    it 'returns 404 for non-existent product' do
      update_params = {
        product: {
          name: 'iPhone 16'
        }
      }
      
      patch '/api/v1/products/99999', params: update_params
      
      expect(response).to have_http_status(:not_found)
    end

    it 'returns 422 when validation fails' do
      update_params = {
        product: {
          name: '',
          price: product.price
        }
      }
      
      patch "/api/v1/products/#{product.id}", params: update_params
      
      expect(response).to have_http_status(:unprocessable_entity)
      
      json_response = JSON.parse(response.body)
      expect(json_response).to have_key('errors')
    end

    it 'partially updates fields' do
      update_params = {
        product: {
          description: 'Updated description'
        }
      }
      
      patch "/api/v1/products/#{product.id}", params: update_params
      
      expect(response).to have_http_status(:ok)
      
      product.reload
      expect(product.description).to eq('Updated description')
      expect(product.name).to eq('iPhone 15')
    end
  end

  describe 'DELETE /api/v1/products/:id' do
    it 'deletes the product and returns 204' do
      delete "/api/v1/products/#{product.id}"
      
      expect(response).to have_http_status(:no_content)
      expect(response.body).to be_empty
      expect(Product.find_by(id: product.id)).to be_nil
    end

    it 'returns 404 for non-existent product' do
      delete '/api/v1/products/99999'
      
      expect(response).to have_http_status(:not_found)
    end

    it 'decreases product count' do
      expect {
        delete "/api/v1/products/#{product.id}"
      }.to change(Product, :count).by(-1)
    end
  end
end
