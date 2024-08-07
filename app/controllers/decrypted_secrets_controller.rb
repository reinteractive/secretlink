class DecryptedSecretsController < ApplicationController
  include RetrieveSecret
  before_action :retrieve_secret
  before_action :require_validated_email

  def create
    begin
      @unencrypted_secret = SecretService.decrypt_secret!(@secret, params[:key])
    rescue => e
      notify_exception(e)
      flash.now[:error] = "An error occurred while trying to decrypt the secret, please ask #{@secret.from_email} to send it again."
    end
    render 'secrets/show'
  end

end
