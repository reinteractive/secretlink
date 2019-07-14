class OauthCallbacksController < ApplicationController

  def google
    email = request.env['omniauth.auth'] && request.env['omniauth.auth']['info'] &&
      request.env['omniauth.auth']['info']['email']

    user = User.find_or_initialize_by(email: email)
    if user.persisted?
      handle_persisted_user(user)
    else
      handle_new_user(user)
    end
  end

  def auth_failure
    flash[:error] = t('oauth.failed')
    redirect_to root_path
  end

  private

  def handle_persisted_user(user)
    if !user.confirmed?
      redirect_to user_confirmation_path(confirmation_token: user.confirmation_token)
    elsif user.confirmed? && user.encrypted_password.blank?
      token = update_password_token(user)
      redirect_to edit_user_setup_url(reset_password_token: token)
    else
      flash[:error] = t('oauth.already_registered')
      redirect_to new_user_session_path
    end
  end

  def handle_new_user(user)
    user.skip_confirmation_notification!
    if user.save
      redirect_to user_confirmation_path(confirmation_token: user.confirmation_token)
    else
      handle_unauthorised and return if user.errors.added?(:email, t('field_errors.unauthorised'))
      # This may not be necessary because a failed oauth calls directly
      # to auth_failure, but keeping this here as a safeguard
      auth_failure and return if user.errors.added?(:email, :blank)
      handle_unknown_error(user)
    end
  end

  def handle_unknown_error(user)
    # We're intentionally raising an error here
    # So tests will catch when creation of user with email only fails
    raise user.errors.full_messages.to_s
  end

  def handle_unauthorised
    flash[:error] = "Email #{t('field_errors.unauthorised')}"
    redirect_to root_path
  end

  def update_password_token(user)
    raw, enc = Devise.token_generator.generate(User, :reset_password_token)

    user.reset_password_token = enc
    user.reset_password_sent_at = Time.current.utc
    user.save(validate: false)
    user.reload
    raw
  end

end
