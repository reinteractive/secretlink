class AuthTokensController < ApplicationController

  def show
    auth_token = AuthToken.find_by_hashed_token(params[:id])
    if auth_token
      session[:email] = auth_token.email
      auth_token.delete
      redirect_to new_secret_path
    else
      flash[:message] = "Token not found"
      render :new
    end
  end

  def new
    if session[:email]
      flash.now[:message] = "You have already verified your email as #{session[:email]}.
      If you want to view and create secrets with this address, click
      <a href='secrets/new'>here</a>."
    end
  end

  def create
    auth_token = AuthToken.new(auth_token_params).generate
    auth_token.notify(request.protocol + request.host_with_port)
    flash[:message] = "A token has been generated and sent to #{auth_token.email}"
    render :new
  end

  private

  def auth_token_params
    params.require(:auth_token).permit(:email)
  end

end