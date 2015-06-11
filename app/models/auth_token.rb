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
    authorised_domains = Rails.application.config.topsekrit_domains_allowed_to_create_secrets
    email_domain = email.to_s.split('@')[1]
    if authorised_domains && email_domain && [authorised_domains].flatten.exclude?(email_domain)
      errors.add(:email, "Email addresses @#{email_domain} are not authorised to create secrets")
    end
    true
  end

end
