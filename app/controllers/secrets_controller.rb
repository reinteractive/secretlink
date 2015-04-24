class SecretsController < ApplicationController

  before_filter :check_auth_token, :retrieve_secret, only: :show
  before_filter :check_session, only: [:new, :create]

  def show
    @secret = Secret.find_by_uuid(params[:uuid])
  end

  def new
    @secret = Secret.new
    @secrets = Secret.created_by_email(session[:email])
  end

  def create
    @secret = SecretService.encrypt_secret(secret_params, request.protocol + request.host_with_port)
    if @secret.persisted?
      flash[:message] = "The secret has been encrypted and an email sent to the recipient"
      redirect_to new_secret_path
    else
      @secrets = Secret.where(from_email: session[:email])
      render :new
    end
  end

  private

  def secret_params
    params.require(:secret).permit(:title, :to_email, :secret, :comments, :expire_at, :secret_file)
      .merge(from_email: session[:email])
  end

  def check_auth_token
    auth_token = AuthToken.find_by_hashed_token(params[:auth_token])
    if auth_token
      session[:email] = auth_token.email
      auth_token.delete
    end
  end

end