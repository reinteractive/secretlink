class SecretsController < ApplicationController
  include RetrieveSecret
  before_filter :retrieve_secret, only: :show
  before_filter :require_validated_email, only: [:new, :create]

  def show
    # As the receipient has now clicked a link, we know their email address is also
    # valid, so we will validate them so they can painlessly send a new secret if
    # they like as well.
    validate_email!(@secret.to_email)
  end

  def new
    @secret = Secret.new(from_email: validated_email)
  end

  def create
    @secret = SecretService.encrypt_new_secret(secret_params)
    if @secret.persisted?
      flash[:message] = "The secret has been encrypted and an email sent to the recipient, feel free to send another secret!"
      redirect_to new_secret_path
    else
      flash.now[:message] = @secret.errors.full_messages.join("<br/>".html_safe)
      render :new
    end
  end

  private

  def secret_params
    params.require(:secret).permit(:title, :to_email, :secret, :comments,
                                   :expire_at, :secret_file).tap do |p|
      p[:from_email] = validated_email
    end
  end

end
