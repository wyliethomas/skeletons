# frozen_string_literal: true

SecureHeaders::Configuration.default do |config|
  config.x_frame_options = "DENY"
  config.x_content_type_options = "nosniff"
  config.x_xss_protection = "1; mode=block"
  config.x_download_options = "noopen"
  config.x_permitted_cross_domain_policies = "none"
  config.referrer_policy = %w[origin-when-cross-origin strict-origin-when-cross-origin]

  # Content Security Policy
  config.csp = {
    default_src: %w['self'],
    font_src: %w['self' data:],
    img_src: %w['self' data: https:],
    object_src: %w['none'],
    script_src: %w['self'],
    style_src: %w['self' 'unsafe-inline'],
    connect_src: %w['self'],
    base_uri: %w['self'],
    form_action: %w['self'],
    frame_ancestors: %w['none'],
    upgrade_insecure_requests: true
  }

  # Disable features that might be used for tracking or fingerprinting
  config.x_permitted_cross_domain_policies = "none"
end
