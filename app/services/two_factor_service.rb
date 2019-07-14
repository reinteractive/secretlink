class TwoFactorService
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def issue_otp_secret
    secret = User.generate_otp_secret
    user.otp_secret = secret
    secret
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

    result =
      if user.valid_password?(current_password)
        validate_and_consume_otp(otp_attempt, otp_secret)
      else
        user.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
        false
      end

    user.clean_up_passwords
    result
  end

  def enable_otp_without_password(otp_secret, otp_attempt)
    validate_and_consume_otp(otp_attempt, otp_secret)
  end

  def disable_otp(current_password)
    user.update_with_password(current_password: current_password, otp_required_for_login: false)
  end

  private

  def validate_and_consume_otp(otp_attempt, otp_secret)
    if user.validate_and_consume_otp!(otp_attempt, otp_secret: otp_secret)
      user.update_attributes(otp_secret: otp_secret, otp_required_for_login: true)
      true
    else
      user.errors.add(:otp_attempt, otp_attempt.blank? ? :blank : :invalid)
      false
    end
  end
end
