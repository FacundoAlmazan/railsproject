require "open-uri"

puts "Eliminando datos existentes..."
SoldProduct.destroy_all
Sale.destroy_all
ProductVariant.destroy_all
Product.destroy_all
Category.destroy_all
User.destroy_all

#Reiniciar los contadores de IDs en SQLite
ActiveRecord::Base.connection.transaction do
  %w[users categories products product_variants sales sold_products].each do |table|
    ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='#{table}'") rescue nil
  end
end


puts "Creando categorías..."
categories = %w[Zapatillas Ropa Accesorios]
categories.each { |category_name| Category.find_or_create_by!(name: category_name) }

puts "Creando productos y variantes..."
30.times do |i|
  category = Category.all.sample

  product = Product.create!(
    name: "Producto #{i + 1}",
    description: "Descripción del producto #{i + 1}.",
    price: rand(10.0..100.0).round(2),
    category: category
  )

  # Asignar imagen si existe
  file_path = Rails.root.join("app/assets/images/zapa6.png")
  if File.exist?(file_path)
    file = File.open(file_path)
    product.image.attach(io: file, filename: "zapa6.png", content_type: "image/png")
  else
    puts "Advertencia: No se encontró la imagen predeterminada para los productos."
  end

  # Crear variantes del producto
  5.times do
    ProductVariant.create!(
      product: product,
      size: %w[S M L XL].sample,
      color: %w[Rojo Azul Verde Negro].sample,
      stock: rand(5..20)
    )
  end
end

puts "Creando usuarios..."
users_data = [
  { username: "MarceloBielsa", email: "admin@gmail.com", password: "adminpass", role: "admin", phone: "123456789" },
  { username: "JulioFalcioni", email: "gerente@gmail.com", password: "gerentepass", role: "manager", phone: "987654321" },
  { username: "DiegoPabloSimeone", email: "empleado@gmail.com", password: "empleadopass", role: "employee", phone: "567891234" }
]

users = users_data.map { |user_params| User.create!(user_params) } # Crear usuarios respetando validaciones

puts "Creando ventas..."
20.times do |i|
  user = users.sample # Selección de usuario vendedor
  sold_products_attributes = []

  # Seleccionar entre 1 y 3 variantes con stock
  variants = ProductVariant.where("stock > ?", 0).sample(rand(1..3))
  next if variants.empty? # Evita ventas sin productos

  variants.each do |variant|
    quantity = rand(1..[variant.stock, 3].min) # Evita vender más stock del disponible
    sold_products_attributes << {
      product_variant_id: variant.id,
      quantity: quantity,
      price: variant.product.price
    }
  end

  sale = Sale.create(
    user: user,
    customer_id: rand(1000..9999),
    sold_products_attributes: sold_products_attributes
  )

  if sale.persisted?
    puts "Venta #{i + 1} creada exitosamente."
  else
    puts "No se pudo crear la venta #{i + 1}: #{sale.errors.full_messages.join(', ')}"
  end
end

puts "Datos de prueba generados exitosamente."
