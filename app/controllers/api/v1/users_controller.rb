class Api::V1::UsersController < ApplicationController
  before_action :valid_auth_token, only: [:show, :index, :update, :destroy]
  before_action :correct_user, only: [:update, :destroy]
  protect_from_forgery with: :null_session
  respond_to :json

  def index
    respond_with User.all
  end

  def show
    user = User.find(params[:id])
    if user
      render json: user
    else
      head 404
    end
  end

  def update
    user = current_user
    if user.update(user_params)
      render json: current_user
    else
      render json: user.errors.full_messages
    end
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: {'user' => user, 'activation_token' => user.activation_token}
    else
      render json: {'errors' => user.errors.full_messages}
    end
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