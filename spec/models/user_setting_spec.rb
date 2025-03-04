require 'rails_helper'

RSpec.describe UserSetting, type: :model do
  describe 'constants' do
    it 'has the correct default email template path' do
      expect(UserSetting::DEFAULT_SEND_SECRET_EMAIL_TEMPLATE_PATH).to eq(
        'secret_mailer/secret_notification_editable.html.erb'
      )
    end
  end
end
