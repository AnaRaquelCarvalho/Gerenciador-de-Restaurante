class Admin::OrdersController < AdminController
  before_action :set_admin_order, only: %i[ show edit update destroy mark_as_preparing mark_as_delivered ]

  # GET /admin/orders
  def index
    # Filtramos apenas pedidos pagos ou em processo, ignorando os abandonados (pending)
    # Organizamos por status: primeiro os pagos (novos), depois preparando
    @not_fulfilled_orders = Order.where(status: [ :paid, :preparing ])
                                 .where(fullfiled: false)
                                 .order(created_at: :desc)

    @fulfilled_orders = Order.where(fullfiled: true)
                             .or(Order.where(status: :delivered))
                             .order(updated_at: :desc)
  end

  def show
  end

  def edit
  end

  # Novas ações para o fluxo da cozinha
  def mark_as_preparing
    @admin_order.preparing! # Muda status para 3
    redirect_to admin_orders_path, notice: "Pedido ##{@admin_order.id} está na chapa!"
  end

  def mark_as_delivered
    @admin_order.update(status: :delivered, fullfiled: true) # Muda status para 4 e marca como entregue
    redirect_to admin_orders_path, notice: "Pedido ##{@admin_order.id} finalizado!"
  end

  # PATCH/PUT /admin/orders/1
  def update
    respond_to do |format|
      if @admin_order.update(admin_order_params)
        format.html { redirect_to admin_order_path(@admin_order), notice: "Pedido atualizado." }
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
      format.html { redirect_to admin_orders_path, notice: "Pedido excluído.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def set_admin_order
    @admin_order = Order.find(params[:id])
  end

  def admin_order_params
    # Note que mantive 'fullfiled' com um 'L' apenas, conforme seu banco de dados
    params.require(:order).permit(:customer_email, :fullfiled, :total, :address, :status)
  end
end
