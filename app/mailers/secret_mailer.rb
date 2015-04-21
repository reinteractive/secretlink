class SecretMailer < ActionMailer::Base

  def secret_notification(secret, request_host)
    @request_host = request_host
    @secret = secret
    @auth_token = AuthToken.create(email: secret.from_email).generate
    mail(to: secret.to_email, from: 'noreply@snapsecret.com', subject: 'A secret has been shared with you via SnapSecret')
  end

  def consumnation_notification(secret)
    @secret = secret
    mail(to: secret.from_email, from: 'noreply@snapsecret.com', subject: 'Secret consumed on snapsecret')
  end

end