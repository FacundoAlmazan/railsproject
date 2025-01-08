class StorefrontController < ApplicationController
    def home
      @products = Product.active
    end
  end