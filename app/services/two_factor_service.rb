class TwoFactorService
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def issue_otp_secret
    user.otp_secret = User.generate_otp_secret
  end

  def generate_otp_provisioning_uri
    issuer = 'Secret Link'
    issuer += ' (dev)' if Rails.env.development?
    label = "#{issuer}:#{user.email}"
    user.otp_provisioning_uri(label, issuer: issuer)
  end

  # Update model with params only if otp_attempt and current_password are correct
  def enable_otp(otp_secret, otp_attempt, current_password)
    user.assign_attributes(otp_secret: otp_secret, otp_required_for_login: true)

    password_valid = user.valid_password?(current_password)
    otp_valid = user.validate_and_consume_otp!(otp_attempt, otp_secret: otp_secret)

    result =
      if otp_valid && password_valid
        user.save! # Intentionally raising error here. This should not happen
      else
        user.valid?
        user.errors.add(:otp_attempt, otp_attempt.blank? ? :blank : :invalid) if !otp_valid
        user.errors.add(:current_password, current_password.blank? ? :blank : :invalid) if !password_valid
        false
      end

    user.clean_up_passwords
    result
  end

  def otp_attempt_error?
    user.errors[:otp_attempt].any?
  end

  def disable_otp(current_password)
    user.update_with_password(current_password: current_password, otp_required_for_login: false)
  end
end
