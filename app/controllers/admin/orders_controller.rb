class Admin::OrdersController < AdminController
  before_action :set_admin_order, only: %i[ show edit update destroy ]

  # GET /admin/orders
  def index
    # Como o Model é Order e a tabela é orders, o Rails se entende perfeitamente aqui
    # @admin_orders = Order.all
    @not_fulfilled_orders = Order.where(fullfiled: false).order(created_at: :asc)
    @fulfilled_orders = Order.where(fullfiled: true).order(created_at: :asc)
    # @admin_orders = Order.where(fullfiled: false).order(created_at: :asc)
  end

  def show
  end

  def new
    @admin_order = Order.new
  end

  def edit
  end

  # POST /admin/orders
  def create
    @admin_order = Order.new(admin_order_params)

    respond_to do |format|
      if @admin_order.save
        # Ajustado para redirecionar dentro do namespace admin
        format.html { redirect_to [ :admin, @admin_order ], notice: "Pedido criado com sucesso." }
        format.json { render :show, status: :created, location: @admin_order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/orders/1
  def update
    respond_to do |format|
      if @admin_order.update(admin_order_params)
        # Ajustado para redirecionar dentro do namespace admin
        format.html { redirect_to [ :admin, @admin_order ], notice: "Pedido atualizado com sucesso.", status: :see_other }
        format.json { render :show, status: :ok, location: @admin_order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin_order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @admin_order.destroy!

    respond_to do |format|
      format.html { redirect_to admin_orders_path, notice: "Pedido excluído com sucesso.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    def set_admin_order
      # Use .find(params[:id]) se estiver em versões anteriores ou se o .expect falhar
      @admin_order = Order.find(params[:id])
    end

    def admin_order_params
      # Corrigido: :addressS para :address e verificado :fullfiled (com um 'l')
      params.require(:order).permit(:customer_email, :fullfiled, :total, :address)
    end
end
