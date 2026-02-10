class AdminController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!

  def index
    @orders = Order.where(fullfiled: false).order(created_at: :desc).take(5)
    today_range = Time.now.midnight..Time.now

    @stats_quick = {
      sales: Order.where(created_at: today_range).count,
      # O .to_f garante que nil vire 0.0, evitando o erro no .round()
      revenue: Order.where(created_at: today_range).sum(:total).to_f.round(),
      avg_sale: Order.where(created_at: today_range).average(:total).to_f.round(),
      per_sale: OrderProduct.joins(:order).where(
        orders: { created_at: today_range }
      ).average(:quantity).to_f.round(2)
    }

    @orders_by_day = Order.where("created_at > ?", Time.now - 7.days).order(:created_at)
    @orders_by_day = @orders_by_day.group_by { |order| order.created_at.to_date }
    data_hash = @orders_by_day.transform_values { |orders| orders.sum(&:total) }

    @revenue_by_day = (0..6).map do |i|
      day_date = Date.today - i.days
      day_name = day_date.strftime("%A")
      [ day_name, data_hash.fetch(day_date, 0) ]
    end.reverse
  end
end
