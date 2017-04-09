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

  def retrieve_secret
    @secret = Secret.where(uuid: params[:id]).first
    case
    when @secret.expired?
      flash[:error] = "Sorry, that secret has expired, please ask the person who sent it to you to send it again."
      redirect_to(new_auth_token_path)
    when @secret.present? && SecretService.correct_key?(@secret, params[:key])
      @secret
    else
      flash[:error] = "Sorry, we couldn't find that secret"
      redirect_to(new_auth_token_path)
    end
  end

  def notify_exception(exception)
    if Rails.env.production?
      Bugsnag.notify(exception)
    else
      raise exception
    end
  end

end
