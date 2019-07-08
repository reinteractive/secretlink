module AuthorisationHelpers
  def configure_authorisation(system_type, domain = "")
    allow(Rails.configuration).to receive(:topsekrit_authorisation_setting).and_return(system_type)
    allow(Rails.configuration).to receive(:topsekrit_authorised_domain).and_return(domain)
  end

  def issue_reset_password_token!(user)
    raw, enc = Devise.token_generator.generate(User, :reset_password_token)
    user.update_attributes(reset_password_token: enc, reset_password_sent_at: Time.current.utc)
    raw
  end
end
