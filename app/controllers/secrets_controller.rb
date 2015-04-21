class SecretsController < ApplicationController

  before_filter :check_auth_token, :retrieve_secret, only: :show
  before_filter :check_session, only: [:new, :create]

  def show
    begin
      @unencrypted_secret = SecretService.decrypt_secret(@secret, params[:secret_key])
    rescue StandardError => e
      flash[:message] = "An error occurred while trying to decrypt the secret: #{e}"
    end
  end

  def new
    @secret = Secret.new
  end

  def create
    @secret = SecretService.encrypt_secret(secret_params, request.protocol + request.host_with_port)
    if @secret.persisted?
      flash[:message] = "The secret has been encrypted and an email sent to the recipient"
      redirect_to new_secret_path
    else
      render :new
    end
  end

  private

  def secret_params
    params.require(:secret).permit(:title, :to_email, :secret, :comments, :expire_at, :secret_file)
      .merge(from_email: session[:email])
  end

  private

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

  def check_auth_token
    auth_token = AuthToken.find_by_hashed_token(params[:auth_token])
    if auth_token
      session[:email] = auth_token.email
      auth_token.delete
    end
  end

  def check_session
    redirect_to new_auth_token_path if session[:email].blank?
  end

end