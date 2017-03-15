class DecryptedSecretsController < ApplicationController

  before_filter :retrieve_secret
  before_filter :check_session

  def create

    auth_token = AuthToken.find_by_hashed_token(session[:auth_token])
    if auth_token then
      session.delete :auth_token
      auth_token.delete
    end

    begin
      @unencrypted_secret = SecretService.decrypt_secret(@secret, params[:secret_key])
    rescue StandardError => e
      flash.now[:error] = "An error occurred while trying to decrypt the secret: #{e}"
    end
    render 'secrets/show'
  end

end
