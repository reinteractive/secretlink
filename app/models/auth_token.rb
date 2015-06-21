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
    if closed && email_domain_does_not_match?
      errors.add(:email, "Only email from #{authorised_domain} are authorised to create secrets")
    end
  end

  def authorised_domain
    Rails.configuration.topsekrit_authorised_domain
  end

  def closed
    Rails.configuration.topsekrit_authorisation_setting == :closed
  end

  def email_domain_does_not_match?
    AuthorisedEmailService.email_domain_does_not_match?(email)
  end

end
