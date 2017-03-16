class Api::V1::UsersController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :json

  def index
    respond_with User.all
  end

  def show
    respond_with User.find(params[:id])
  end

  def update
    respond_with User.update(params[:id], params[:user])
  end

  def create
    respond_with User.create(user_params)
    redirect_back('http://localhost:3000')
  end

  def destroy
    respond_with User.destroy(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end