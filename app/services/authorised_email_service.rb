module AuthorisedEmailService
  class << self
    def closed_system?
      authorisation == :closed
    end

    def limited_system?
      authorisation == :limited
    end

    def open_system?
      authorisation == :open
    end

    def closed_or_limited_system?
      closed_system? || limited_system?
    end

    def authorised_to_register?(email)
      if closed_or_limited_system?
        email_domain_matches?(email).present?
      else
        true
      end
    end

    def email_domain_matches?(email)
      regexp = Regexp.new(".+#{authorised_domain}\\z")
      email.to_s.match(regexp)
    end

    def email_domain_does_not_match?(email)
      !email_domain_matches?(email)
    end

    def authorisation
      Rails.configuration.topsekrit_authorisation_setting
    end

    def authorised_domain
      Rails.configuration.topsekrit_authorised_domain
    end
  end

end
