module AuthorisationHelpers
  def configure_authorisation(system_type, domain = "")
    allow(Rails.configuration).to receive(:topsekrit_authorisation_setting).and_return(system_type)
    allow(Rails.configuration).to receive(:topsekrit_authorised_domain).and_return(domain)
  end
end
