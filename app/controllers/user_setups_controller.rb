class UserSetupsController < ApplicationController
  def edit
    @user = User.with_reset_password_token(original_token)

    if @user
      @tfa_service = TwoFactorService.new(@user)
      @tfa_service.issue_otp_secret
      @otp_provisioning_uri = @tfa_service.generate_otp_provisioning_uri
    else
      redirect_to root_path, notice: t('devise.passwords.no_token')
    end
  end

  def update
    @setup_service = UserSetupService.new(
      password_params[:reset_password_token],
      TwoFactorService
    )

    if @setup_service.run(password_params, two_factor_params)
      @setup_service.user.after_database_authentication
      flash[:notice] = t('devise.passwords.updated')
      sign_in(@setup_service.user)

      redirect_to dashboard_path
    else
      @user = @setup_service.user
      @tfa_service = @setup_service.tfa_service
      @otp_provisioning_uri = @tfa_service.generate_otp_provisioning_uri

      render :edit
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation, :reset_password_token)
  end

  def two_factor_params
    params.require(:user).permit(:otp_required_for_login, :otp_secret, :otp_attempt, :password)
  end

  def original_token
    @original_token ||= params[:reset_password_token]
  end
end
