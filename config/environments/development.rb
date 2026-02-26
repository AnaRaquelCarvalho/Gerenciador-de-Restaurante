require "active_support/core_ext/integer/time"

Rails.application.configure do
  # ==========================================================
  # CONFIGURAÇÕES DE GEMS EXTERNAS (Stripe & Active Storage)
  # ==========================================================

  config.active_storage.service = :local

  # Configurações do Stripe
  config.stripe = {
    publishable_key: ENV["STRIPE_PUBLISHABLE_KEY"],
    secret_key: ENV["STRIPE_SECRET_KEY"],
    webhook_secret: ENV["STRIPE_WEBHOOK_SECRET"] # Padronizado com os nomes comuns
  }

  # ==========================================================
  # CONFIGURAÇÕES DE URL (Vital para o Checkout!)
  # ==========================================================

  # Isso permite que o Rails gere links completos (http://localhost:3000/...)
  config.action_controller.default_url_options = { host: "localhost", port: 3000 }
  config.action_mailer.default_url_options = { host: "localhost", port: 3000 }

  # ==========================================================
  # CONFIGURAÇÕES PADRÃO DO RAILS 8
  # ==========================================================

  config.enable_reloading = true
  config.eager_load = false
  config.consider_all_requests_local = true
  config.server_timing = true

  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true
    config.cache_store = :memory_store
    config.public_file_server.headers = { "Cache-Control" => "public, max-age=#{2.days.to_i}" }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  config.active_support.deprecation = :log
  config.i18n.raise_on_missing_translations = false
  config.action_view.annotate_rendered_view_with_filenames = true
  config.action_controller.action_on_unpermitted_parameters = :raise

  # Evita bloqueios de conexão no ambiente Windows/Localhost
  config.hosts.clear
end
