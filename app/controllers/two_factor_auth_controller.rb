class TwoFactorAuthController < AuthenticatedController
  def edit
    @tfa_service = TwoFactorService.new(current_user)
    @tfa_service.issue_otp_secret
    @otp_provisioning_uri = @tfa_service.generate_otp_provisioning_uri
  end

  def update
    @tfa_service = TwoFactorService.new(current_user)

    valid =
      if enabling_otp?
        @tfa_service.enable_otp(
          two_factor_params[:otp_secret],
          two_factor_params[:otp_attempt],
          two_factor_params[:current_password]
        )
      else
        @tfa_service.disable_otp(two_factor_params[:current_password])
      end

    if valid
      verb = @tfa_service.user.otp_required_for_login ? 'enabled' : 'disabled'
      redirect_to root_path, notice: t('two_factor.update_success', verb: verb)
    else
      flash[:error] = t('two_factor.update_failed')

      @otp_provisioning_uri = @tfa_service.generate_otp_provisioning_uri
      render :edit
    end
  end

  private

  def enabling_otp?
    two_factor_params[:otp_required_for_login] == '1'
  end

  def two_factor_params
    params.require(:user).permit(:otp_required_for_login, :otp_secret, :otp_attempt, :current_password)
  end
end
