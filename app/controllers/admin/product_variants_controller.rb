class Admin::ProductVariantsController < Admin::DashboardController
    before_action :set_product, only: [:new, :create, :edit, :update]
    before_action :set_product_variant, only: [:edit, :update, :destroy]

    def new
        @product = Product.find(params[:product_id])
        @product_variant = @product.product_variants.build
    end

    def create
        @product_variant = @product.product_variants.build(product_variant_params)
        if @product_variant.save
            redirect_to edit_admin_product_path(@product), notice: "Variante agregada correctamente."
        else
            flash.now[:alert] = "Hubo un problema al agregar la variante."
            render :new, status: :unprocessable_entity
        end
    end

    def edit
    end

    def update
        if @product_variant.update(product_variant_params)
            redirect_to edit_admin_product_path(@product), notice: "Variante actualizada correctamente."
        else
            flash.now[:alert] = "Hubo un problema al actualizar la variante."
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
    @product_variant.destroy
    respond_to do |format|
        format.html { redirect_to edit_admin_product_path(@product_variant.product), notice: "Variante eliminada correctamente." }
        format.turbo_stream { render turbo_stream: turbo_stream.remove(@product_variant) }
    end
    end

    private

    def set_product
        @product = Product.find(params[:product_id])
    end

    def set_product_variant
        @product_variant = ProductVariant.find(params[:id])
    end

    def product_variant_params
        params.require(:product_variant).permit(:size, :color, :stock)
    end
end

  