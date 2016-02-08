class AuthTokenMailer < BaseMailer

  def auth_token(email, tokens, request_host)
    @email = email
    @request_host = request_host
    @token = tokens.compact.join('-')
    mail(to: email, subject: 'Topsekrit authentication token')
  end

end
