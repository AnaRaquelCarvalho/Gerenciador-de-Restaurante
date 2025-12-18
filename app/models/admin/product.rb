# app/models/admin/product.rb
class Admin::Product < ApplicationRecord
  self.table_name = "admin_products" # ⚠️ somente se sua tabela for admin_products

  belongs_to :category
  has_one_attached :image
end
