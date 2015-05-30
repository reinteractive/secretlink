class AuthToken < ActiveRecord::Base
  validates :email, email: true
  validate :email_domain_authorised

  def generate
    update_attributes(hashed_token: SecureRandom.hex, expire_at: Time.now + 7.days)
    self
  end

  def notify(request_host)
    AuthTokenMailer.auth_token(email, hashed_token, request_host).deliver_now
  end

  def email_domain_authorised
    email_domain = email.to_s.split('@')[1]
    if Rails.configuration.snapsecret_authorisation_setting == 'closed' &&
      email_domain != Rails.configuration.snapsecret_authorised_domain
      errors.add(:email, "Email addresses @#{email_domain} are not authorised to create secrets")
    end
  end

end