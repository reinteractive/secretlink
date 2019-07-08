class UserSetupService
  attr_reader :user, :tfa_service

  def initialize(token, tfa_service_klass)
    reset_password_token = Devise.token_generator.digest(self, :reset_password_token, token)

    @user = User.find_or_initialize_with_error_by(:reset_password_token, reset_password_token)
    @tfa_service = tfa_service_klass.new(@user)
  end

  def run(password_params, tfa_params)
    password, confirmation = password_params.values_at :password, :password_confirmation
    otp_required, otp_secret, otp_attempt = tfa_params.values_at :otp_required_for_login, :otp_secret, :otp_attempt

    if token_valid? && user_valid?(password, confirmation)
      return enable_otp(otp_secret, otp_attempt) if otp_required == '1'
      user.save! #This case should not happen
    else
      false
    end
  end

  private

  def enable_otp(secret, attempt)
    if tfa_service.enable_otp_without_password(secret, attempt)
      user.save! # This should never raise an errror
    else
      false
    end
  end

  def user_valid?(password, confirmation)
    if password.present?
      user.assign_attributes(password: password, password_confirmation: confirmation)
      user.valid?
    else
      user.errors.add(:password, :blank)
      false
    end
  end

  def token_valid?
    user.persisted? && user.reset_password_period_valid?
  end
end
