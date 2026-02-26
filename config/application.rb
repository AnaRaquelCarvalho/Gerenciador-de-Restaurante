require_relative "boot"
require "rails/all"
require "stripe"

Bundler.require(*Rails.groups)

module GerenciadorDeRestaurante
  class Application < Rails::Application
    config.load_defaults 8.1

    # ✅ CORREÇÃO PARA WINDOWS + POSTGRES:
    # Força o Rails a tratar tudo como UTF-8 puro para evitar o erro 500
    config.encoding = "utf-8"
    Encoding.default_external = Encoding::UTF_8
    Encoding.default_internal = Encoding::UTF_8

    config.autoload_lib(ignore: %w[assets tasks])

    # ✅ CONFIGURAÇÃO DE ASSETS
    config.assets.paths << Rails.root.join("app/assets/images")
    config.assets.precompile += %w[ *.png *.jpg *.jpeg *.svg *.webp ]
  end
end
