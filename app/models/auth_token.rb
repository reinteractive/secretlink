class AuthToken < ActiveRecord::Base
  validates :email, email: true
  def generate
    update_attributes(hashed_token: SecureRandom.hex, expire_at: Time.now + 7.days)
    self
  end

  def notify(request_host)
    AuthTokenMailer.auth_token(email, hashed_token, request_host).deliver_now
  end
end
