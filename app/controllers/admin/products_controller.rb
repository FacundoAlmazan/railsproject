class Admin::ProductsController < Admin::DashboardController

  before_action :set_product, only: [:edit, :update, :destroy]

  #def index
  # @products = Product.active
  #end

  def index
    # Solo obtenemos los productos activos
    @q = Product.active.ransack(params[:q])
    @products = @q.result(distinct: true)
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admin_products_path, notice: "Producto creado exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    if @product.update(product_params)
      redirect_to admin_products_path, notice: "Producto actualizado exitosamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  #def destroy
  #  @product.update(deactivated_at: Time.current, stock: 0)
  #  redirect_to admin_products_path, notice: "Producto eliminado exitosamente."
  #end

  def destroy
    if @product.deactivate!
      redirect_to admin_products_path, notice: "Producto eliminado exitosamente."
    else
      redirect_to admin_products_path, alert: "No se pudo eliminar el producto."
    end
  end

  def change_stock
    if @product.update(stock: params[:stock])
      redirect_to admin_products_path, notice: "Stock actualizado exitosamente."
    else
      redirect_to admin_products_path, alert: "No se pudo actualizar el stock."
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end


  private
  def product_params
    params.require(:product).permit(:name, :price, :stock, :description, :category, :color, :size, :image)
  end

end