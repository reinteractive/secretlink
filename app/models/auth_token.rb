class AuthToken < ActiveRecord::Base
  validates :email, email: { message: 'does not look like a valid email' }
  validate  :email_domain_authorised

  before_validation :set_defaults

  private

  def set_defaults
    self.hashed_token = SecureRandom.hex
    self.expire_at = Time.current + 7.days
  end

  def email_domain_authorised
    if limited? && email_domain_does_not_match?
      errors.add(:base, "Only email addresses from #{authorised_domain} are authorised to create secrets")
    end
  end

  def authorised_domain
    Rails.configuration.topsekrit_authorised_domain
  end

  def limited?
    [:closed, :limited].include?(Rails.configuration.topsekrit_authorisation_setting)
  end

  def email_domain_does_not_match?
    AuthorisedEmailService.email_domain_does_not_match?(email)
  end

end
