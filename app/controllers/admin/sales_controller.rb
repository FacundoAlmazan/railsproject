class Admin::SalesController < Admin::DashboardController
    before_action :set_sale, only: [:show ,:edit, :update, :destroy, :cancel]
  
    def index
      @sales = Sale.active.includes(:user, :sold_products).order(created_at: :desc).paginate(page: params[:page], per_page: 10)
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
  
      if @sale.save_with_stock_validation
        redirect_to admin_sales_path, notice: 'Venta registrada exitosamente.'
      else
        flash.now[:alert] = @sale.errors.full_messages.join(', ')
        render :new, status: :unprocessable_entity
      end
    end

    def show
    end

    def edit
    end

    def update
    end
  
    def destroy
    end

    def cancel
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
  
