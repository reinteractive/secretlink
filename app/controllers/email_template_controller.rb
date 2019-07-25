class EmailTemplateController < AuthenticatedController
  def edit
    @settings = current_user.settings

    unless @settings.send_secret_email_template.present?
      @settings.send_secret_email_template = build_default_email
    end
  end

  def update
    current_user.settings.update!(settings_params) # This step should never fail
    redirect_to edit_email_template_path, notice: t('.success')
  end

  def build_default_email
    @secret = Secret.new(from_email: current_user.email)

    ViewBuilder.new(
      UserSetting::DEFAULT_SEND_SECRET_EMAIL_TEMPLATE_PATH,
      view_context.__binding__
    ).run
  end

  def settings_params
    params.require(:user_setting).permit(:send_secret_email_template)
  end
end
