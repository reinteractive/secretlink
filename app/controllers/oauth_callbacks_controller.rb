class OauthCallbacksController < ApplicationController

  def google
    email = request.env['omniauth.auth'] && request.env['omniauth.auth']['info'] &&
      request.env['omniauth.auth']['info']['email']
    if email
      flash[:message] = "Authenticated as \"#{email}\" via google"
      session[:email] = email
      redirect_to new_secret_path
    else
      flash[:error] = 'Authentication via google failed'
      redirect_to new_auth_token_path
    end
  end

  def auth_failure
    flash[:error] = 'Authentication failed'
    redirect_to new_auth_token_path
  end

end