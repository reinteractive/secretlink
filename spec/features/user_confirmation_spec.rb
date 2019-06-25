require 'rails_helper'

describe 'User confirmation' do
  let! (:user) { create :user, :unconfirmed }

  describe 'successful' do
    it 'confirms the user' do
      visit user_confirmation_path(confirmation_token: user.confirmation_token)

      expect(page).to have_content I18n.t('devise.confirmations.confirmed')
      expect(user.reload.confirmed_at).to_not be_nil
    end

    it 'asks the user to set the password and redirects to dashboard' do
      visit user_confirmation_path(confirmation_token: user.confirmation_token)

      expect(page).to have_content('Set your password')
      expect(user.encrypted_password).to be_blank

      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
      click_on 'Set my password'

      expect(page).to have_content I18n.t('devise.passwords.updated')
      expect(page).to have_content 'Dashboard'

      expect(user.reload.encrypted_password).to_not be_blank
    end
  end

  describe 'token is nonexistent' do
    it 'shows error' do
      visit user_confirmation_path(confirmation_token: 'nonexistent')
      expect(page).to have_content 'Confirmation token is invalid'
    end
  end
end
