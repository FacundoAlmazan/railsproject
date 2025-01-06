class StorefrontController < ApplicationController
    def home
      @products = Product.all
    end
  end