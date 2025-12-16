class Admin < ApplicationRecord
  devise :database_authenticatable,
         :registerable,      # 👈 cadastro
         :recoverable,
         :rememberable,
         :validatable
end
