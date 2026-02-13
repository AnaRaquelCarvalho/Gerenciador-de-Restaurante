class CategoriesController < ApplicationController
    def show
        @category = Category.find(params[:id])
        @products = @category.products # Isso garante que @products exista na view
    end
end
