class Api::V1::UsersController < ApplicationController
  before_action :valid_auth_token, only: [:show, :update, :destroy]
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
    respond_with user.update(user_params)
  end

  def create
    User.create(user_params)
    redirect_to params[:url]
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
    user = User.find_by_auth_token(response.headers['Authorize'])
    render json: {errors: "unauthorized"}, status: 401
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end