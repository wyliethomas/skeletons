module Api
  module V1
    class UsersController < BaseController
      before_action :set_user, only: [:show, :update, :destroy]

      # GET /api/v1/users
      def index
        @users = User.all.page(params[:page]).per(params[:per_page] || 20)

        render json: {
          data: @users.map { |user| user_json(user) },
          meta: pagination_meta(@users)
        }
      end

      # GET /api/v1/users/:id
      def show
        render json: { data: user_json(@user) }
      end

      # POST /api/v1/users
      def create
        @user = User.new(user_params)

        if @user.save
          render json: { data: user_json(@user) }, status: :created
        else
          render json: {
            error: "User creation failed",
            details: @user.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/users/:id
      def update
        if @user.update(user_params)
          render json: { data: user_json(@user) }
        else
          render json: {
            error: "User update failed",
            details: @user.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/users/:id
      def destroy
        @user.destroy
        head :no_content
      end

      private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:email, :name, :password, :password_confirmation)
      end

      def user_json(user)
        {
          id: user.id,
          email: user.email,
          name: user.name,
          created_at: user.created_at,
          updated_at: user.updated_at
        }
      end
    end
  end
end
