class Api::V1::SessionsController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :json

  def create
    user = User.find_by_email(params['email'])
    if user && user.activated? && user.authenticate(params['password'])
      user.generate_auth_token!
      user.save
      respond_with user
    else
      render json: { errors: "Invalid email or password" }, status: 422
    end
  end

  def destroy
    user = User.find_by_auth_token(params[:id])
    user.generate_auth_token!
    user.save
    head 204
  end
end