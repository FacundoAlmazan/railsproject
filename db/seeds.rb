require "open-uri"

puts "Eliminando datos existentes..."
ProductVariant.destroy_all
Product.destroy_all
Category.destroy_all

puts "Creando categorías..."
categories = %w[Zapatillas Ropa Accesorios]
categories.each do |category_name|
  Category.find_or_create_by!(name: category_name)
end

# Crear categoría predeterminada si no existe
default_category = Category.find_or_create_by!(name: "Default")

# Asignar categoría predeterminada a productos sin categoría (si fuera necesario)
puts "Actualizando productos sin categoría..."
Product.where(category_id: nil).update_all(category_id: default_category.id)

puts "Creando productos y variantes..."
30.times do |i|
  category = Category.all.sample
  
  # Creación del producto
  product = Product.create!(
    name: "Producto #{i + 1}",
    description: "Descripción del producto #{i + 1}.",
    price: rand(10.0..100.0).round(2),
    category: category
  )
  
  # Asignación de una imagen al producto
  file_path = Rails.root.join("app/assets/images/zapa6.png")
  if File.exist?(file_path)
    file = File.open(file_path)
    product.image.attach(io: file, filename: "zapa6.png", content_type: "image/png")
  else
    puts "Advertencia: No se encontró la imagen predeterminada para los productos."
  end
  
  # Creación de variantes del producto
  10.times do |j|
    ProductVariant.create!(
      product: product,
      size: %w[S M L XL].sample,
      color: %w[Rojo Azul Verde Negro].sample,
      stock: rand(1..20)
    )
  end
end

puts "Datos cargados exitosamente."
