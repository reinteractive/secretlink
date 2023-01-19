class AuthTokenMailer < ApplicationMailer

  def auth_token(email, token)
    @email = email
    @token = token
    mail(to: email, subject: 'Topsekrit authentication token')
  end

end
