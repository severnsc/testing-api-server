class Api::V1::SessionsController < ApplicationController
  respond_to :json

  def create
    user = User.find_by_email(params[:user][:email])
    if user && user.authenticate(params[:user][:password])
      redirect_to params[:url]
    else
      redirect_back fallback_location: params[:url]
    end
  end

  def destroy
  end
end