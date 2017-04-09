class AuthTokensController < ApplicationController

  def show
    auth_token = AuthToken.find_by(hashed_token: params[:id])
    if auth_token.present?
      validate_email!(auth_token.email)
      auth_token.delete
      redirect_to new_secret_path
    else
      flash[:message] = "Sorry, we don't know who you are, try sending a new token!"
      render :new
    end
  end

  def new
    if validated_email?
      flash.now[:message] = "You have already verified your email as #{validated_email}.<br/>
      If you want, you can just go ahead and <a href=\"#{ new_secret_path }\">create another secret</a> with this address."
    end
  end

  def create
    auth_token = AuthTokenService.generate(auth_token_params)
    if auth_token.valid?
      flash.now[:message] = "A token has been generated and sent to #{auth_token_params['email']}"
    else
      flash.now[:message] = auth_token.errors.full_messages.join("<br/>".html_safe)
    end
    render :new
  end

  private

  def auth_token_params
    params.require(:auth_token).permit(:email)
  end

end
