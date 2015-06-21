class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def development?
    Rails.env.development?
  end

  def check_session
    redirect_to new_auth_token_path if session[:email].blank?
  end

  def retrieve_secret
    @secret = Secret.where(uuid: params[:uuid], from_email: session[:email]).first
    case
    when @secret.blank?
      flash[:error] = "Secret not found"
      redirect_to(new_auth_token_path)
    when @secret.expired?
      flash[:error] = "That secret has expired"
      redirect_to(new_auth_token_path)
    end
    true
  end

end
