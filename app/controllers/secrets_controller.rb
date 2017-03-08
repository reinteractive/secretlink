class SecretsController < ApplicationController

  before_filter :check_auth_token, :retrieve_secret, only: :show
  before_filter :check_session, only: [:new, :create, :edit]

  def show
    @secret = Secret.find_by_uuid(params[:uuid])
  end

  def edit
    @secret = Secret.with_email_and_access_key(session[:email], params[:id]).first
  end

  def new
    @secret = Secret.new(to_email: params[:recipient_email])
  end

  def update
    @secret = SecretService.encrypt_existing_secret(params[:id], secret_params, request.protocol + request.host_with_port)
    if @secret.persisted?
      flash[:message] = "The secret has been encrypted and an email sent to the recipient"
      redirect_to root_url
    else
      render :edit
    end
  end

  def create
    @secret = SecretService.encrypt_new_secret(secret_params, request.protocol + request.host_with_port)
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

  def check_auth_token
    auth_token = AuthToken.find_by_hashed_token(params[:auth_token])
    if auth_token
      session[:email] = auth_token.email
      session[:auth_token] = params[:auth_token]
    end
  end

end
