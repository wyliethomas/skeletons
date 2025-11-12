require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"

Bundler.require(*Rails.groups)

module ProjectName
  class Application < Rails::Application
    config.load_defaults 7.1

    # API-only mode
    config.api_only = true

    # Enable CORS
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins ENV.fetch("CORS_ORIGINS", "").split(",")
        resource "*",
          headers: :any,
          methods: [:get, :post, :put, :patch, :delete, :options, :head],
          credentials: true
      end
    end

    # Sidekiq for background jobs
    config.active_job.queue_adapter = :sidekiq

    # Timezone
    config.time_zone = "UTC"
    config.active_record.default_timezone = :utc

    # Generators
    config.generators do |g|
      g.test_framework :rspec
      g.factory_bot dir: "spec/factories"
      g.skip_routes true
      g.helper false
      g.assets false
    end
  end
end
