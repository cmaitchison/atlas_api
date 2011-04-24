LpApi::Application.configure do
  
  config.cache_classes = true
  
  config.consider_all_requests_local       = false

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  config.log_level = :info

  # Use a different cache store in production
  config.cache_store = :file_store, "/tmp/cache"

  config.serve_static_assets = true

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify
end
