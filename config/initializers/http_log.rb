HttpLog.configure do |config|

  # Enable or disable all logging
  config.enabled = true

  # You can assign a different logger
  config.logger = Logger.new($stdout)

  # I really wouldn't change this...
  config.severity = Logger::Severity::DEBUG



  # ...or log all request as a single line by setting this to `true`
  config.compact_log = true

  # Prettify the output - see below
  config.color = false

  # Limit logging based on URL patterns
  config.url_whitelist_pattern = /.*/
  config.url_blacklist_pattern = nil
end
