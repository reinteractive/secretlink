class AuthTokenMailer < ActionMailer::Base

  def auth_token(email, token, request_host)
    @email = email
    @request_host = request_host
    @token = token
    mail(to: email, subject: 'SnapSecret authentication token')
  end

end
