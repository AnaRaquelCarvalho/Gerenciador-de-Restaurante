class HomeController < ApplicationController
  def index
    # Acrescentado .with_attached_image para carregar as fotos e evitar lentidão
    @main_categories = Category.with_attached_image.take(4)
  end
end