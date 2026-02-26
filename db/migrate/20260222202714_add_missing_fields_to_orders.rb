class AddMissingFieldsToOrders < ActiveRecord::Migration[7.1]
  def change
    # Comente ou remova a linha do status se ela já existir
    # add_column :orders, :status, :integer

    add_column :orders, :customer_email, :string unless column_exists?(:orders, :customer_email)
    add_column :orders, :stripe_checkout_id, :string unless column_exists?(:orders, :stripe_checkout_id)
  end
end
