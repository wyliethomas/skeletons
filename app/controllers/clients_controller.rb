class ClientsController < ApplicationController
  skip_before_action :require_client, only: [:new, :create]
  before_action :redirect_if_has_client, only: [:new, :create]

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)
    @client.users << current_user
    current_user.role = 'admin'

    if @client.save
      redirect_to root_path, notice: "Welcome! Your organization has been set up."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @client = current_client
  end

  def edit
    @client = current_client
  end

  def update
    @client = current_client

    if @client.update(client_params)
      redirect_to client_path, notice: "Organization updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def client_params
    params.require(:client).permit(:name)
  end

  def redirect_if_has_client
    if current_user.client.present?
      redirect_to root_path, alert: "You already belong to an organization"
    end
  end
end
