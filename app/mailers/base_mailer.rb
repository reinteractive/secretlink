class BaseMailer < ActionMailer::Base
  default from: "noreply@snapsecret.com"
  layout 'application_mail'
end