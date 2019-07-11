require 'rails_helper'

describe 'Updating email template', js: true do
  let!(:user) { create :user }

  before do
    login_as(user)
    visit edit_email_template_path
  end

  describe 'successfully' do
    it 'updates the default email template' do
      expect(page).to have_content('Email Template')

      editor = find('trix-editor')
      editor.assert_text("#{user.email} has shared a secret with you via SecretLink.org")

      editor.click.set('Edited email template')
      click_on I18n.t('buttons.update')

      expect(page).to have_content I18n.t('email_template.update.success')
      expect(user.settings.reload.send_secret_email_template).to match /Edited email template./
    end
  end

  describe 'Sending with updated email template' do
    let(:user) { create :user }
    let(:to_email)   { "to@example.com" }

    before do
      user.settings.update!(send_secret_email_template: 'Updated email template.')

      login_as(user)
      visit new_secret_path
      fill_in "Title", with: "Super Secret"
      fill_in "Recipient", with: to_email
      fill_in "Secret", with: "AbC123"
      fill_in "Comments", with: "Some super secret info"
      fill_in "Expire at", with: (Time.current + 1.day).strftime("%d %B, %Y")
      click_button "Send your Secret"
    end

    it 'is sent with the secret message' do
      mail = ActionMailer::Base.deliveries.last
      expect(mail.html_part.body.to_s).to match(/Updated email template./)
      expect(mail.text_part.body.to_s).to match(/Updated email template./)
    end
  end
end
