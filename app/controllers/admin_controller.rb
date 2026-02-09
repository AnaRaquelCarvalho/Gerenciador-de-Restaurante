class AdminController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!

  def index
    # Busca os últimos 5 pedidos pendentes
    @orders = Order.where(fullfiled: false).order(created_at: :desc).take(5)

    # Definimos o período de hoje (meia-noite até agora)
    today_range = Time.now.midnight..Time.now

    # Estatísticas Rápidas com tratamento para valores nulos (nil)
    @stats_quick = {
      sales: Order.where(created_at: today_range).count,
      # .to_f transforma nil em 0.0, evitando erro no .round()
      revenue: Order.where(created_at: today_range).sum(:total).to_f.round(),
      avg_sale: Order.where(created_at: today_range).average(:total).to_f.round(),
      per_sale: OrderProduct.joins(:order).where(
        orders: { created_at: today_range }
      ).average(:quantity).to_f.round(2)
    }

    # Lógica do Gráfico de Receita dos últimos 7 dias
    @orders_by_day = Order.where("created_at > ?", Time.now - 7.days).order(:created_at)
    @orders_by_day = @orders_by_day.group_by { |order| order.created_at.to_date }

    # Mapeia os dados existentes no banco
    data_hash = @orders_by_day.transform_values { |orders| orders.sum(&:total) }

    # Cria uma lista dos nomes dos dias da semana (em inglês, como no seu original)
    # Indo de 6 dias atrás até hoje
    @revenue_by_day = (0..6).map do |i|
      day_date = Date.today - i.days
      day_name = day_date.strftime("%A")
      [ day_name, data_hash.fetch(day_date, 0) ]
    end.reverse # Reverte para que o dia atual seja o último no gráfico
  end
end
