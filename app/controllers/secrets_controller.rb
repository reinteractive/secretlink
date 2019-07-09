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

  def create
    @secret = SecretService.encrypt_new_secret(secret_params)
    if @secret.persisted?
      if @secret.no_email?
        CopyService.new(session).prepare(@secret)

        flash[:message] = t('secrets.create.success.without_email')
        redirect_to copy_secrets_path
      else
        flash[:message] = t('secrets.create.success.with_email')
        redirect_to dashboard_path
      end
    else
      flash.now[:error] = @secret.errors.full_messages.join("<br/>".html_safe)
      render :new
    end
  end

  def copy
    @data = CopyService.new(session).copy!
    redirect_to root_path unless @data
  end

  private

  def secret_params
    params.require(:secret).permit(:title, :to_email, :secret, :comments,
                                   :expire_at, :secret_file, :no_email).tap do |p|
      p[:from_email] = current_user.email
    end
  end
end
