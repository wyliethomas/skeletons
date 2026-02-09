# frozen_string_literal: true

# Rack::Attack Configuration
#
# Implements rate limiting to prevent brute force attacks and API abuse

class Rack::Attack
  ### Configure Cache ###

  # Use Redis for distributed rate limiting
  # Note: Rack::Attack uses its own cache interface
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  ### Throttle Configuration ###

  # Throttle login attempts by IP address
  # Limit: 5 login attempts per 20 seconds per IP
  throttle('logins/ip', limit: 5, period: 20.seconds) do |req|
    if req.path == '/signin' && req.post?
      req.ip
    end
  end

  # Throttle login attempts by email
  # Limit: 5 login attempts per 20 seconds per email
  throttle('logins/email', limit: 5, period: 20.seconds) do |req|
    if req.path == '/signin' && req.post?
      # Extract email from request body
      req.params['email'].to_s.downcase.presence
    end
  end

  # Throttle password reset requests by IP
  # Limit: 3 password reset requests per hour per IP
  throttle('password_reset/ip', limit: 3, period: 1.hour) do |req|
    if req.path == '/forgot' && req.post?
      req.ip
    end
  end

  # Throttle password reset requests by email
  # Limit: 3 password reset requests per hour per email
  throttle('password_reset/email', limit: 3, period: 1.hour) do |req|
    if req.path == '/forgot' && req.post?
      req.params['email'].to_s.downcase.presence
    end
  end

  # Throttle signup attempts by IP
  # Limit: 5 signups per hour per IP
  throttle('signups/ip', limit: 5, period: 1.hour) do |req|
    if req.path == '/signup' && req.post?
      req.ip
    end
  end

  # Throttle API requests by IP
  # Limit: 300 requests per 5 minutes per IP
  throttle('api/ip', limit: 300, period: 5.minutes) do |req|
    if req.path.start_with?('/api/')
      req.ip
    end
  end

  ### Custom Throttle Response ###

  # Customize the response when rate limit is exceeded
  self.throttled_responder = lambda do |request|
    match_data = request.env['rack.attack.match_data']
    now = match_data[:epoch_time]

    headers = {
      'Content-Type' => 'text/html',
      'Retry-After' => (match_data[:period] - (now % match_data[:period])).to_s
    }

    message = <<~HTML
      <!DOCTYPE html>
      <html>
      <head>
        <title>Too Many Requests</title>
        <style>
          body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            background: #f5f5f5;
          }
          .container {
            text-align: center;
            padding: 2rem;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            max-width: 500px;
          }
          h1 { color: #dc2626; margin: 0 0 1rem 0; }
          p { color: #6b7280; line-height: 1.5; }
          .retry { color: #3b82f6; font-weight: 600; }
        </style>
      </head>
      <body>
        <div class="container">
          <h1>Too Many Requests</h1>
          <p>You've made too many requests. Please wait a moment before trying again.</p>
          <p class="retry">Retry after: #{headers['Retry-After']} seconds</p>
        </div>
      </body>
      </html>
    HTML

    [429, headers, [message]]
  end

  ### Logging ###

  # Log blocked requests
  ActiveSupport::Notifications.subscribe('throttle.rack_attack') do |name, start, finish, request_id, payload|
    req = payload[:request]
    Rails.logger.warn("[Rack::Attack] Throttled #{req.ip} - #{req.path} - #{payload[:matched]}")
  end
end
