# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Clear existing products to make seeds idempotent
Product.destroy_all

# Create example products
products = [
  {
    name: 'iPhone 15',
    description: 'Latest generation iPhone with advanced camera and A18 processor',
    price: 999.99
  },
  {
    name: 'MacBook Pro 16"',
    description: 'Powerful laptop perfect for developers and creative professionals',
    price: 2499.99
  },
  {
    name: 'AirPods Pro',
    description: 'Wireless earbuds with active noise cancellation',
    price: 249.99
  }
]

products.each do |product_data|
  Product.create!(product_data)
  puts "Created product: #{product_data[:name]}"
end

puts "✓ Seeding complete! #{Product.count} products created."

