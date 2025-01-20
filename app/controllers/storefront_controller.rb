class StorefrontController < ApplicationController

  def home
    @q = Product.active.ransack(params[:q])
    # Aplicamos paginación al resultado de Ransack
    @products = @q.result(distinct: true).paginate(page: params[:page], per_page: 16) # Cambia '10' al número de elementos por página que prefieras
  end
  
end

