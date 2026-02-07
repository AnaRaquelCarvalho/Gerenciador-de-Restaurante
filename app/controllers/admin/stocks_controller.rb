class Admin::StocksController < AdminController
  before_action :set_product
  before_action :set_admin_stock, only: %i[show edit update destroy]

  # GET /admin/products/:product_id/stocks
  def index
    @admin_stocks = @product.stocks
  end

  # GET /admin/products/:product_id/stocks/1
  def show
  end

  # GET /admin/products/:product_id/stocks/new
  def new
    @admin_stock = @product.stocks.new
  end

  # GET /admin/products/:product_id/stocks/1/edit
  def edit
  end

  # POST /admin/products/:product_id/stocks
  def create
    @admin_stock = @product.stocks.new(admin_stock_params)

    if @admin_stock.save
      redirect_to admin_product_stocks_path(@product),
                  notice: "Stock was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /admin/products/:product_id/stocks/1
  def update
    if @admin_stock.update(admin_stock_params)
      redirect_to admin_product_stocks_path(@product),
                  notice: "Stock was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /admin/products/:product_id/stocks/1
  def destroy
    @admin_stock.destroy!

    redirect_to admin_product_stocks_path(@product),
                notice: "Stock was successfully destroyed."
  end

  private

  # Define o produto pai para todas as ações (recurso aninhado)
  def set_product
    @product = Product.find(params[:product_id])
  end

  # Define o estoque específico
  def set_admin_stock
    @admin_stock = @product.stocks.find(params[:id])
  end

  # Permite apenas os parâmetros necessários para estoque
  def admin_stock_params
    params.require(:stock).permit(:amount, :size)
  end
end
