class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  force_ssl unless: :development?

  def development?
    Rails.env.development?
  end
end
