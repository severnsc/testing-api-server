module Authenticable

  def current_user
    current_user ||= User.find_by_auth_token(request.headers['Authorize'])
  end

  def authenticate_with_token!
    render json: { errors: "Not authenticated" },
                status: :unauthorized unless current_user.present?
  end
end