class SecretMailerPreview < ActionMailer::Preview
  def secret_notification
    SecretMailer.secret_notification(Secret.first)
  end

  def consumnation_notification
    SecretMailer.consumnation_notification(Secret.first)
  end
end
