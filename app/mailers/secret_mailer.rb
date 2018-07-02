class SecretMailer < BaseMailer

  def secret_notification(secret)
    @secret = secret
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

end
