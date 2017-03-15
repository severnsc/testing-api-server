class Api::V1::SessionsController < ApplicationController
  respond_to :json

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      redirect_to params[:url]
    else
      redirect_back('http://google.com')
    end
  end

  def destroy
  end
end