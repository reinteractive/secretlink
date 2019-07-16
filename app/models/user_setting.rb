class UserSetting < ActiveRecord::Base
  DEFAULT_SEND_SECRET_EMAIL_TEMPLATE_PATH =
    'secret_mailer/secret_notification_editable.html.erb'.freeze

  belongs_to :user
end
