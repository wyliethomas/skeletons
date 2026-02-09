class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Include authentication and multi-tenancy concerns
  include Authenticatable
  include CurrentClient

  # Authenticate all requests by default
  before_action :authenticate_user
end
