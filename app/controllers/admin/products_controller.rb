class Admin::ProductsController < AdminController
  before_action :set_admin_product, only: %i[show edit update destroy]

  # GET /admin/products
  def index
    @admin_products = Admin::Product.all
  end

  # GET /admin/products/1
  def show
  end

  # GET /admin/products/new
  def new
    @admin_product = Admin::Product.new
  end

  # GET /admin/products/1/edit
  def edit
  end

  # POST /admin/products
  def create
    @admin_product = Admin::Product.new(admin_product_params)

    if @admin_product.save
      redirect_to admin_product_path(@admin_product),
                  notice: "Product was successfully created.",
                  status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /admin/products/1
  def update
    if @admin_product.update(admin_product_params)
      redirect_to admin_product_path(@admin_product),
                  notice: "Product was successfully updated.",
                  status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /admin/products/1
  def destroy
    @admin_product.destroy
    redirect_to admin_products_path,
                notice: "Product was successfully destroyed.",
                status: :see_other
  end

  private

  def set_admin_product
    @admin_product = Admin::Product.find(params[:id])
  end

  def admin_product_params
    params.require(:admin_product).permit(
      :name,
      :description,
      :price,
      :category_id,
      :active,
      :image
    )
  end
end
