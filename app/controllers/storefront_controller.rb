class StorefrontController < ApplicationController

  def home
    @q = Product.active.ransack(params[:q])
    if params[:q].present? && params[:q][:name_or_description_cont].present?
      @products = @q.result(distinct: true)
    else
      @products = Product.active
    end
    @products = @products.paginate(page: params[:page], per_page: 16)
  end

  def show
    @product = Product.find(params[:id])
  end
  
end

