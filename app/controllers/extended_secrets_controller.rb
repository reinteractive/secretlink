class ExtendedSecretsController < AuthenticatedController
  def update
    @secret = current_user.secrets.find(params[:id])

    if @secret.expired? && !@secret.extended?
      @secret.extend_expiry!
      ActivityLogger.new(current_user).perform(Secret::ACTIVITY_LOG_KEYS[:extended], @secret)
      redirect_to dashboard_path, notice: t('secrets.extended_expiry', title: @secret.title)
    else
      # This case should not happen base on UI
      redirect_to dashboard_path
    end
  end
end
