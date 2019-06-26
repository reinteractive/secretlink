class OauthCallbacksController < ApplicationController

  def google
    email = request.env['omniauth.auth'] && request.env['omniauth.auth']['info'] &&
      request.env['omniauth.auth']['info']['email']

    user = User.new(email: email)
    user.skip_confirmation_notification!

    if user.save
      redirect_to user_confirmation_path(confirmation_token: user.confirmation_token)
    else
      handle_email_taken and return if user.errors.added?(:email, :taken)
      handle_unauthorised and return if user.errors.added?(:email, t('field_errors.unauthorised'))
      # This may not be necessary because a failed oauth calls directly
      # to auth_failure, but keeping this here as a safeguard
      auth_failure and return if user.errors.added?(:email, :blank)
      handle_unknown_error(user)
    end
  end

  def auth_failure
    flash[:error] = t('oauth.failed')
    redirect_to root_path
  end

  private

  def handle_email_taken
    flash[:error] = t('oauth.already_registered')
    redirect_to new_user_session_path
  end

  def handle_unknown_error(user)
    # We're intentionally raising an error here
    # So tests will catch when creation of user with email only fails
    raise user.errors.full_messages.to_s
  end

  def not_allowed?(email)
    !AuthorisedEmailService.authorised_to_register?(email)
  end

  def handle_unauthorised
    flash[:error] = "Email #{t('field_errors.unauthorised')}"
    redirect_to root_path
  end
end
