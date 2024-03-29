class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :validated_email

  def require_validated_email
    redirect_to new_auth_token_path unless validated_email?
  end

  def validated_email
    session[:validated_email]
  end

  def validated_email?
    session[:validated_email].present?
  end

  def validate_email!(email)
    session[:validated_email] = email
  end

  def notify_exception(exception)
    if Rails.env.production?
      Bugsnag.notify(exception)
    else
      raise exception
    end
  end

end
