class Api::V1::UsersController < ApplicationController
  before_action :valid_auth_token, only: [:show, :index, :update, :destroy]
  before_action :correct_user, only: [:update, :destroy]
  protect_from_forgery with: :null_session
  respond_to :json

  def index
    respond_with User.all
  end

  def show
    respond_with User.find(params[:id])
  end

  def update
    user = current_user
    user.update(user_params)
    render json: current_user
  end

  def create
    user = User.create(user_params)
    render json: {'user' => user, 'activation_token' => user.activation_token}
  end

  def destroy
    current_user.destroy
    head 204
  end

  private

  def valid_auth_token
    render json: {errors: "unauthorized"}, status: 401 unless current_user
  end

  def correct_user
    user = User.find_by_auth_token(request.headers['Authorize'])
    render json: {errors: "unauthorized"}, status: 401 unless user == current_user
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end