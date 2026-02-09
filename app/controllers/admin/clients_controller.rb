module Admin
  class ClientsController < BaseController
    def index
      @clients = Client.includes(:users)
                       .order(created_at: :desc)

      # Calculate stats
      @total_clients = @clients.count
      @total_active_users = User.where(status: 'ACTIVE').count
    end

    def show
      @client = Client.includes(:users).find_by!(urlkey: params[:id])
    end

    def new
      @client = Client.new
      @client.users.build # Build initial user for the form
    end

    def create
      @client = Client.new(client_params)

      # Set the initial user as admin of their client account
      if @client.users.any?
        @client.users.first.role = 'admin'
      end

      if @client.save
        user = @client.users.first
        if user
          redirect_to admin_client_path(@client), notice: "Client created successfully. Initial login: #{user.email}"
        else
          redirect_to admin_client_path(@client), notice: "Client created successfully, but no user was created."
        end
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @client = Client.find_by!(urlkey: params[:id])
    end

    def update
      @client = Client.find_by!(urlkey: params[:id])

      if @client.update(client_params)
        redirect_to admin_client_path(@client), notice: "Client updated successfully"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def client_params
      params.require(:client).permit(
        :name,
        users_attributes: [:first_name, :last_name, :email, :password, :password_confirmation]
      )
    end
  end
end
