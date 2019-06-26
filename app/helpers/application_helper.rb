module ApplicationHelper

  def to_email_placeholder
    if closed? || limited?
      "email@" + Rails.configuration.topsekrit_authorised_domain
    else
      "email@example.com"
    end
  end

  def from_email_placeholder
    current_user.email
  end

  # A closed system only allows secrets to be sent to and from email
  # addresses that are in the topsekrit_authorised_domain
  def closed?
    Rails.configuration.topsekrit_authorisation_setting == :closed
  end

  # A limited system only allows secrets to be sent from an email
  # address that are in the topsekrit_authorised_domain
  def limited?
    Rails.configuration.topsekrit_authorisation_setting == :limited
  end

  def email_does_not_match?(email)
    AuthorisedEmailService.email_domain_does_not_match?(email)
  end

  def auth_new_page?
    request.path == '/auth_tokens/new'
  end

  def flash_display_type(key)
    HashWithIndifferentAccess.new(alert: 'danger', error: 'danger')[key] || 'success'
  end
end
