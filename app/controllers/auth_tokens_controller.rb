class AuthTokensController < ApplicationController

  def new
  end

  def show
    keys = params[:id].to_s.split('-')
    hashed_token = keys[0]
    access_key = keys[1]
    auth_token = AuthToken.find_by_hashed_token(hashed_token)
    if auth_token
      session[:email] = auth_token.email
      auth_token.delete
      if Secret.exist?(auth_token.email, access_key)
        redirect_to edit_secret_path(access_key)
      else
        flash[:message] = "Secret not found"
        render :new
      end
    else
      flash[:message] = "Token not found"
      render :new
    end
  end

  def new
    if session[:email]
      flash.now[:message] = "You have already verified your email as #{session[:email]}.<br/>
      If you want, you can just go ahead and <a href=\"#{ new_secret_path }\">create another secret</a> with this address."
    end
  end

  def create
    if auth_token_params[:email].present?
      AuthTokenService.generate(auth_token_params, (request.protocol + request.host_with_port) )
      flash.now[:message] = "A token has been generated and sent to #{auth_token_params['email']}"
    else
      flash.now[:message] = "Sorry, but we need your email address to send the auth token to"
    end
    render :new
  end

  private

  def auth_token_params
    params.require(:auth_token).permit(:email, :recipient_email)
  end

end
