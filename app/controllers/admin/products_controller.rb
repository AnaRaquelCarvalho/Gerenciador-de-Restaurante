class Admin::ProductsController < ApplicationController
  layout "admin"

  before_action :set_product, only: %i[show edit update destroy]

  def index
    @products = Product.all
  end

  def show
  end

  def new
    @product    = Product.new
    @categories = Category.all
  end

  def edit
    @categories = Category.all
  end

  def create
    @product    = Product.new(product_params)
    @categories = Category.all

    if @product.save
      redirect_to admin_product_path(@product),
                  notice: "Produto criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @categories = Category.all

    if @product.update(product_params)
      redirect_to admin_product_path(@product),
                  notice: "Produto atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to admin_products_path,
                notice: "O produto foi destruído com sucesso."
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(
      :name,
      :description,
      :price,
      :category_id,
      :active,
      images: []
    )
  end
end
