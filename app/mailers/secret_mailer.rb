class SecretMailer < BaseMailer

  def secret_notification(secret, custom_message = nil)
    @secret = secret
    @editable_content = custom_message || load_default_content

    mail(to: @secret.to_email,
         reply_to: @secret.from_email,
         subject: "SecretLink.org: A secret has been shared with you - Reference #{@secret.uuid}")
  end

  def consumnation_notification(secret)
    @secret = secret
    mail(to: @secret.from_email,
         reply_to: @secret.to_email,
         subject: "Your secret was consumed on SecretLink.org - Reference #{@secret.uuid}")
  end

  private

  def load_default_content
    ViewBuilder.new(
      UserSetting::DEFAULT_SEND_SECRET_EMAIL_TEMPLATE_PATH,
      view_context.__binding__
    ).run
  end
end
