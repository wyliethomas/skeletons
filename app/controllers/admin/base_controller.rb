module Admin
  class BaseController < ApplicationController
    before_action :authenticate_user
    before_action :require_super_admin
    skip_before_action :require_client  # Admin controllers don't need current_client
    layout 'admin'

    private

    def require_super_admin
      unless current_user&.super_admin?
        redirect_to root_path, alert: "Access denied. Super admin privileges required."
      end
    end
  end
end
