class AuthorisedEmailService

  def self.email_domain_matches?(email)
    email =~ Regexp.new(".+#{Rails.configuration.topsekrit_authorised_domain}\\z")
  end

  def self.email_domain_does_not_match?(email)
    !email_domain_matches?(email)
  end

end