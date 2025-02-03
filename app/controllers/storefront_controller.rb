class StorefrontController < ApplicationController

  def home
    @q = Product.active.ransack(params[:q])

    if params[:q].present?
      @products = @q.result(distinct: true)

      # Filtrar por stock si el checkbox NO está marcado (mostrando solo productos con stock)
      if params[:q][:with_stock] == "1"
        @products = @products.joins(:product_variants).where("product_variants.stock > ?", 0).distinct
      end

      # Filtrar por categoría si se selecciona una
      if params.dig(:q, :category_id_eq).present?
        @products = @products.where(category_id: params[:q][:category_id_eq])
      end
    else
      @products = Product.active
    end

    @products = @products.paginate(page: params[:page], per_page: 16)
  end

  def show
    @product = Product.active.find(params[:id])
    @variants = @product.product_variants.active
  end
  
end

