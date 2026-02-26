class CartsController < ApplicationController
  # GET /cart
  def show
    # Garante que seja um array para evitar erros de 'nil' na visualização
    @cart_items = session[:cart] || []

    # Cálculo do total tratando decimais corretamente e multiplicando pela quantidade
    @total = @cart_items.sum { |item| item["price"].to_f * item["quantity"].to_i }
  end

  # POST /cart
  def create
    product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i > 0 ? params[:quantity].to_i : 1
    size = params[:size] || "M"

    session[:cart] ||= []

    # Verifica se o produto com o mesmo tamanho já está no carrinho
    existing_item = session[:cart].find { |item| item["id"] == product.id && item["size"] == size }

    if existing_item
      # Se já existe, apenas incrementa a quantidade
      existing_item["quantity"] = existing_item["quantity"].to_i + quantity
    else
      # Se é novo, adiciona o hash ao array
      session[:cart] << {
        "id" => product.id,
        "name" => product.name,
        "price" => product.price.to_f,
        "size" => size,
        "quantity" => quantity
      }
    end

    redirect_to cart_path, notice: "#{product.name} foi adicionado ao seu carrinho!"
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Desculpe, esse produto não foi encontrado."
  end

  # PATCH/PUT /cart (Adicionado: Para atualizar quantidades no carrinho)
  def update
    index = params[:index].to_i
    new_quantity = params[:quantity].to_i

    if session[:cart] && session[:cart][index]
      if new_quantity > 0
        session[:cart][index]["quantity"] = new_quantity
      else
        session[:cart].delete_at(index) # Remove se a quantidade for zerada
      end
    end

    redirect_to cart_path, notice: "Carrinho atualizado."
  end

  # DELETE /cart (Modificado: Pode remover um item específico ou esvaziar tudo)
  def destroy
    if params[:index].present?
      # Remove um item específico pelo índice do array
      session[:cart].delete_at(params[:index].to_i)
      notice_msg = "Item removido do carrinho."
    else
      # Esvazia o carrinho completamente
      session[:cart] = []
      notice_msg = "O seu carrinho foi esvaziado."
    end

    redirect_to cart_path, notice: notice_msg
  end
end
