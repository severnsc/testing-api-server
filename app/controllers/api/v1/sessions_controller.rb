class Api::V1::SessionsController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :json

  def create
    user = User.find_by_email(params['email'])
    if user && user.authenticate(params['password'])
      respond_with user
    else
      redirect_to 'http://google.com'
    end
  end

  def destroy
  end
end