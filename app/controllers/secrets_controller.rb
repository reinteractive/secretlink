class SecretsController < AuthenticatedController
  include RetrieveSecret
  before_filter :retrieve_secret, only: :show
  before_action :authenticate_user!, except: [:show]

  def show
    # TODO: Should we add a button to encourage the user to register?
  end

  def new
    @secret = Secret.new(from_email: current_user.email)
  end

  def resend
    secret = current_user.secrets.find(params[:id])

    unless secret.expired?
      SecretService.resend_notification(secret)

      flash[:notice] = "The secret was resent to: #{secret.to_email}"
      redirect_to dashboard_path
    else
      flash[:error] = "This secret is expired. Please create a new one."
      redirect_to dashboard_path
    end

  end

  def create
    @secret = SecretService.encrypt_new_secret(secret_params)
    if @secret.persisted?
      flash[:message] = "The secret has been encrypted and an email sent to the recipient, feel free to send another secret!"
      redirect_to dashboard_path
    else
      flash.now[:error] = @secret.errors.full_messages.join("<br/>".html_safe)
      render :new
    end
  end

  private

  def secret_params
    params.require(:secret).permit(:title, :to_email, :secret, :comments,
                                   :expire_at, :secret_file).tap do |p|
      p[:from_email] = current_user.email
    end
  end

end
