class SecretsController < AuthenticatedController
  include RetrieveSecret
  before_filter :retrieve_secret, only: :show
  before_action :authenticate_user!, except: [:show]

  def show
    # TODO: Should we add a button to encourage the user to register?
  end

  def new
    base_secret = current_user.secrets.find_by(uuid: params[:base_id])

    if base_secret.present?
      @secret = Secret.new(
        title: base_secret.title,
        from_email: base_secret.from_email,
        to_email: base_secret.to_email,
        comments: base_secret.comments
      )
    else
      @secret = Secret.new(from_email: current_user.email)
    end
  end

  def extend_expiry
    @secret = current_user.secrets.find(params[:id])

    if @secret.expired? && !@secret.extended?
      @secret.extend_expiry!
      redirect_to dashboard_path, notice: t('secrets.extended_expiry', title: @secret.title)
    else
      # This case should not happen base on UI
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
