module Admin
  class UsersController < BaseController
    def index
      @users = User.includes(:client).order(created_at: :desc)
    end

    def toggle_status
      @user = User.find(params[:id])

      new_status = @user.status == 'ACTIVE' ? 'INACTIVE' : 'ACTIVE'

      if @user.update(status: new_status)
        redirect_to admin_users_path, notice: "User status updated to #{new_status}"
      else
        redirect_to admin_users_path, alert: "Failed to update user status"
      end
    end
  end
end
