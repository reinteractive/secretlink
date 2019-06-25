class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout :layout_by_resource

  def notify_exception(exception)
    if Rails.env.production?
      Bugsnag.notify(exception)
    else
      raise exception
    end
  end

  private

  def layout_by_resource
    if devise_controller?
      "devise"
    else
      "application"
    end
  end
end
