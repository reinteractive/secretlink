class AuthorisedEmailService

  def self.email_domain_matches?(email)
    regexp = Regexp.new(".+#{Rails.configuration.topsekrit_authorised_domain}\\z")
    email.to_s.match(regexp)
  end

  def self.email_domain_does_not_match?(email)
    !email_domain_matches?(email)
  end

end