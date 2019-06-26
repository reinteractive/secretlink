module AuthorisedEmailService
  AUTHORISATION = Rails.configuration.topsekrit_authorisation_setting
  AUTHORISED_DOMAIN = Rails.configuration.topsekrit_authorised_domain

  class << self
    def closed_system?
      AUTHORISATION == :closed
    end

    def limited_system?
      AUTHORISATION == :limited
    end

    def open_system?
      AUTHORISATION == :open
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
      regexp = Regexp.new(".+#{AUTHORISED_DOMAIN}\\z")
      email.to_s.match(regexp)
    end

    def email_domain_does_not_match?(email)
      !email_domain_matches?(email)
    end
  end

end
