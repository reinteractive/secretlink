class UserSetupsController < AuthenticatedController
  def edit
    @tfa_service = TwoFactorService.new(current_user)
    @tfa_service.issue_otp_secret
    @otp_provisioning_uri = @tfa_service.generate_otp_provisioning_uri
  end

  def update
  end
end
