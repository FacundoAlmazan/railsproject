class Admin::ProductsController < Admin::DashboardController
  load_and_authorize_resource
  before_action :set_product, only: [:edit, :update, :destroy]

  #def index
  # @products = Product.active
  #end

  def index
    # Solo obtenemos los productos activos
    @q = Product.active.ransack(params[:q])
    # Aplicamos paginación al resultado de Ransack
    @products = @q.result(distinct: true).paginate(page: params[:page], per_page: 16)
  end

  def show
  end

  def new
    @product = Product.new
    @product.product_variants.build # Inicializa una variante vacía
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
  #  @product.update(deactivated_at: Time.current)
  #  redirect_to admin_products_path, notice: "Producto eliminado exitosamente."
  #end

  def destroy
    if @product.deactivate!
      redirect_to admin_products_path, notice: "Producto eliminado exitosamente."
    else
      redirect_to admin_products_path, alert: "No se pudo eliminar el producto."
    end
  end


  private

  def set_product
    @product = Product.find(params[:id])
  end


  private
  def product_params
    params.require(:product).permit(:name, :price, :description, :category_id, :color, :size, :image, :remove_image, product_variants_attributes: [:id, :size, :color, :stock, :_destroy])
  end

end