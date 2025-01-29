class Admin::SalesController < Admin::DashboardController
  load_and_authorize_resource
  before_action :set_sale, only: [:cancel]
  
  def index
    if params[:include_canceled] == "1"
      @s = Sale.includes(:user, :sold_products).order(created_at: :desc).ransack(params[:q])
    else
      @s = Sale.active.includes(:user, :sold_products).order(created_at: :desc).ransack(params[:q])
    end
  
    @sales = @s.result(distinct: true).paginate(page: params[:page], per_page: 10)
  end
  
  def new
    @sale = Sale.new
    @sale.sold_products.build # Inicializa un producto vendido vacío
  end

  def create  
    @sale = Sale.new(sale_params)
    @sale.user = current_user # Asignamos al empleado actual

    puts "Parámetros de la venta: #{sale_params.inspect}"
    puts "Productos vendidos: #{@sale.sold_products.inspect}"
    puts "Errores en la venta antes de guardar: #{@sale.errors.full_messages}" if @sale.invalid?

    if @sale.save_with_stock_validation
      puts "Venta registrada exitosamente"
      redirect_to (admin_sales_path), notice: 'Venta registrada exitosamente.', status: :see_other 
    else
      puts "Errores al guardar la venta: #{@sale.errors.full_messages}"
      flash.now[:alert] = @sale.errors.full_messages.join(', ')
      render :new, status: :unprocessable_entity
    end
  end

  def cancel
    if @sale.canceled?
      redirect_to admin_sales_path, alert: "La venta ya ha sido cancelada."
    else
      @sale.cancel!
      redirect_to admin_sales_path, notice: "Venta cancelada exitosamente."
    end
  end


  private

  def set_sale
    @sale = Sale.find(params[:id])
  end

  def sale_params
    params.require(:sale).permit(
      :customer_id,
      sold_products_attributes: [:id, :product_variant_id, :quantity, :price, :_destroy]
    )
  end

end
  
