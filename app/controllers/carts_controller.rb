class CartsController < ApplicationController
  # GET /cart
  def show
    # Garante que seja um array para evitar erros de 'nil' na view
    @cart_items = session[:cart] || []

    # Cálculo do total tratando possíveis valores nulos ou strings
    @total = @cart_items.sum { |item| item["price"].to_f }
  end

  # POST /cart
  def create
    # O params[:product_id] deve vir do botão 'Add to Cart'
    product = Product.find(params[:product_id])

    item = {
      "product_id" => product.id,
      "name" => product.name,
      "price" => product.price.to_f,
      "size" => params[:size] || "Padrão" # Captura o 'm' do seu print
    }

    session[:cart] ||= []
    session[:cart] << item

    # Redireciona explicitamente para cart_path (que deve ser /cart)
    redirect_to cart_path, notice: "#{product.name} adicionado ao carrinho!"
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Produto não encontrado."
  end

  # DELETE /cart
  def destroy
    session[:cart] = []
    redirect_to cart_path, notice: "Carrinho esvaziado."
  end
end
