class AuthTokenMailer < BaseMailer

  def auth_token(email, token, request_host)
    @email = email
    @request_host = request_host
    @token = token
    mail(to: email, subject: 'Topsekrit authentication token')
  end

end
