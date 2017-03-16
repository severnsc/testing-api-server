class Api::V1::AccountActivationsController < ApplicationController
  respond_to :json

  def edit
    user = User.find_by_auth_token(params[:id])
    if user && user.authenticated?(:activation, params[:activation_token])
      user.activate
      respond_with user
    else
      render json: {errors: "Bad activation link"}, status: 404
    end
  end
end