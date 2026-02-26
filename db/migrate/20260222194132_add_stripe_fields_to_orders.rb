class AddStripeFieldsToOrders < ActiveRecord::Migration[8.1]
  def change
    add_column :orders, :status, :integer
    add_column :orders, :stripe_checkout_id, :string
  end
end
