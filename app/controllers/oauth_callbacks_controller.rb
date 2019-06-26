class OauthCallbacksController < ApplicationController

  def google
    email = request.env['omniauth.auth'] && request.env['omniauth.auth']['info'] &&
      request.env['omniauth.auth']['info']['email']

    user = User.new(email: email)
    if user.save
      flash[:notice] = t('devise.registrations.signed_up_but_unconfirmed')
      redirect_to root_path
    else
      handle_email_taken and return if user.errors.added?(:email, :taken)
      handle_email_blank and return if user.errors.added?(:email, :blank)
      handle_unknown_error(user)
    end
  end

  def auth_failure
    flash[:error] = 'Authentication failed'
    redirect_to root_path
  end

  private

  def handle_email_taken
    flash[:notice] = "You are already registered with this account. Please login instead."
    redirect_to new_user_session_path
  end

  def handle_email_blank
    flash[:error] = 'Authentication via google failed'
    redirect_to root_path
  end

  def handle_unknown_error(user)
    # We're intentionally raising an error here
    # So tests will catch when creation of user with email only fails
    raise user.errors.full_messages.to_s
  end
end
