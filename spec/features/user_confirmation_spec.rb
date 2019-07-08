require 'rails_helper'

describe 'User confirmation', js: true do
  let!(:user) { create :user, :unconfirmed }
  let!(:otp_secret) { "jk5ap26gyp255cmseomnttmm" }

  before do
    user.otp_secret = otp_secret
    allow(User).to receive(:generate_otp_secret).and_return(otp_secret)

    visit user_confirmation_path(confirmation_token: user.confirmation_token)
  end

  describe 'successful' do
    it 'confirms the user' do
      expect(page).to have_content I18n.t('devise.confirmations.confirmed')
      expect(user.reload.confirmed_at).to_not be_nil
    end

    it 'asks the user to set the password' do
      expect(page).to have_content('Setup login credentials')
      expect(user.encrypted_password).to be_blank

      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
      click_on 'Save'

      expect(page).to have_content I18n.t('welcome')
      expect(page).to have_content 'Create a new secret to send'

      expect(user.reload.encrypted_password).to_not be_blank
    end

    it 'allows the user to enable 2FA' do
      expect(page).to have_content('Setup login credentials')
      expect(user.encrypted_password).to be_blank
      expect(user.otp_required_for_login).to be false

      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'

      check('Enable two factor authentication')
      expect(page).to have_content('Install a two-factor')
      fill_in 'user[otp_attempt]', with: user.current_otp

      click_on 'Save'

      expect(page).to have_content I18n.t('welcome')
      expect(page).to have_content 'Create a new secret to send'
      user.reload

      expect(user.encrypted_password).to_not be_blank
      expect(user.otp_required_for_login).to be true
    end
  end

  describe 'token is nonexistent' do
    it 'shows error' do
      visit user_confirmation_path(confirmation_token: 'nonexistent')
      expect(page).to have_content 'Confirmation token is invalid'
    end
  end

  describe 'password does not match' do
    it 'it fails to update and shows errors' do
      expect(page).to have_content('Setup login credentials')
      expect(user.encrypted_password).to be_blank
      expect(user.otp_required_for_login).to be false

      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'wrong password'

      check('Enable two factor authentication')
      expect(page).to have_content('Install a two-factor')
      fill_in 'user[otp_attempt]', with: user.current_otp
      click_on 'Save'

      expect(page).to have_content "password doesn't match"
      expect(user.reload.encrypted_password).to be_blank
      expect(user.reload.otp_required_for_login).to be false
    end
  end

  describe 'otp is wrong' do
    it 'it fails to update and shows errors' do
      expect(page).to have_content('Setup login credentials')
      expect(user.encrypted_password).to be_blank
      expect(user.otp_required_for_login).to be false

      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'

      check('Enable two factor authentication')
      expect(page).to have_content('Install a two-factor')
      fill_in 'user[otp_attempt]', with: 'wrong otp'
      click_on 'Save'

      expect(page).to have_content "is invalid"
      expect(user.reload.encrypted_password).to be_blank
      expect(user.reload.otp_required_for_login).to be false
    end
  end
end
