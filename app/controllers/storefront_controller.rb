class StorefrontController < ApplicationController

    def index
      @q = Product.active.ransack(params[:q])
      @products = @q.result(distinct: true)
    end
    def home
      @q = Product.active.ransack(params[:q])
      @products = @q.result(distinct: true)
    end
  end