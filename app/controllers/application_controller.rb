class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  force_ssl unless: :development?

  def development?
    Rails.env.development?
  end

  def check_session
    redirect_to new_auth_token_path if session[:email].blank?
  end

  def retrieve_secret
    @secret = Secret.where(uuid: params[:uuid], from_email: session[:email]).first
    if !@secret
      flash[:error] = "Secret not found"
      redirect_to new_auth_token_path
    end
    if @secret.expired?
      flash[:error] = "That secret has expired"
      redirect_to(new_auth_token_path)
    end
    true
  end

end
