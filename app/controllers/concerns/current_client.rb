module CurrentClient
  extend ActiveSupport::Concern

  included do
    helper_method :current_client
    before_action :require_client, except: [:health, :new, :create]
  end

  def current_client
    return nil unless session[:user_id]
    @current_client ||= begin
      user = User.find_by(apikey: session[:user_id])
      user&.client
    end
  end

  def require_client
    unless current_client
      redirect_to new_client_path, alert: "Please set up your organization first"
    end
  end
end
