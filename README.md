# Clonar el repositorio
git clone <URL_DEL_REPOSITORIO>

# Pararse en el directorio con el nombre del proyecto (pruby)
cd <NOMBRE_DEL_PROYECTO>

# Instalar dependencias
bundle install

# Crea, migra y carga datos iniciales
rails db:setup 

# Ejecutar el servidor de desarrollo
./bin/dev

# La aplicación estará disponible en http://localhost:3000


# Decisiones de diseño: 

Intenté no reinventar la rueda como decía la consigna y utilicé algunas gemas como Devise para autenticación, CanCanCan para autorización, Ransack para búsqueda y filtros y WillPaginate para paginación.

Autenticación y administración:

Todo lo relacionado a administración está dentro del namespace admin. (http://localhost:3000/admin)
Se requiere autenticación para acceder a cualquier ruta de administración. 
Si se intenta acceder sin estar logueado, se lo redirige a la pantalla de inicio de sesión en http://localhost:3000/users/sign_in.

Los empleados/gerentes/admins deberían dirigirse directamente a la url de sign-in para acceder al dashboard de administración. El storefront es de libre acceso como decía la consigna.

Variantes de productos:

Se creó un modelo separado (ProductVariant) para manejar variantes de un producto. Por lo que un producto tiene diferentes variantes.
Cada variante tiene talle, color y su propio stock. También tienen su propio borrado lógico.
Los productos (Product) calculan su stock total sumando el stock de sus variantes activas.

Productos vendidos:

Se creó el modelo SoldProduct para representar los productos vendidos en una venta.
SoldProduct une una venta (Sale) con una variante de producto (ProductVariant), 
permitiendo registrar la cantidad vendida de dicha variante y el precio de venta en el momento de la compra.
Esto permite que cada venta guarde el precio exacto de esa variante en ese momento, en lugar de depender del precio actual del producto.