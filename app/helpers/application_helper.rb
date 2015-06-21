module ApplicationHelper

  def to_email_placeholder(secret, email)
    if closed? || limited_and_email_does_not_match?(email)
      '@' + Rails.configuration.topsekrit_authorised_domain
    end
  end

  def closed?
    Rails.configuration.topsekrit_authorisation_setting == :closed
  end

  def limited_and_email_does_not_match?(email)
    limited? && email_does_not_match?(email)
  end

  def limited?
    Rails.configuration.topsekrit_authorisation_setting == :limited
  end

  def email_does_not_match?(email)
    AuthorisedEmailService.email_domain_does_not_match?(email)
  end


end
