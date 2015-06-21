class SecretMailer < BaseMailer

  def secret_notification(secret, request_host)
    @request_host = request_host
    @secret = secret
    @auth_token = AuthToken.create(email: secret.from_email).generate
    mail(to: secret.to_email, subject: 'A secret has been shared with you via Topsekrit')
  end

  def consumnation_notification(secret)
    @secret = secret
    mail(to: secret.from_email, subject: 'Secret consumed on topsekrit')
  end

end
