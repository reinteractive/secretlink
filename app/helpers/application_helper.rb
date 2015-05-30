module ApplicationHelper

  def to_email_placeholder(secret, email)
    if Rails.configuration.snapsecret_authorisation_setting == 'closed' ||
      (Rails.configuration.snapsecret_authorisation_setting == 'limited' &&
       email.split('@').last.to_s != Rails.configuration.snapsecret_authorised_domain)
      '@' + Rails.configuration.snapsecret_authorised_domain
    end
  end

end
