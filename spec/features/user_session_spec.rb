require 'rails_helper'
describe 'User session' do
  describe 'without otp' do
    let(:user) { create :user, :with_secret }

    before do
      visit new_user_session_path
    end

    context 'successful' do
      it 'signs in the user' do
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        click_button "Sign In"

        expect(page).to have_content(I18n.t('devise.sessions.signed_in'))
        expect(page).to have_current_path(root_path)
      end
    end

    context 'failed' do
      it 'does not sign in the user' do
        fill_in "Email", with: user.email
        fill_in "Password", with: "wrong password"
        click_button "Sign In"

        expect(page).to have_content(I18n.t('devise.failure.invalid', authentication_keys: 'Email'))
        expect(page).to have_current_path(new_user_session_path)
      end
    end
  end

  describe 'with otp' do
    let(:user) { create :user, :otp_enabled, :with_secret }

    before do
      visit new_user_session_path
    end

    context 'successful' do
      it 'signs in the user' do
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        fill_in "user[otp_attempt]", with: user.current_otp
        click_button "Sign In"

        expect(page).to have_content(I18n.t('devise.sessions.signed_in'))
        expect(page).to have_current_path(root_path)
      end
    end

    context 'failed' do
      it 'does not sign in the user' do
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        fill_in "user[otp_attempt]", with: 'wrong otp'
        click_button "Sign In"

        expect(page).to have_content(I18n.t('devise.failure.invalid', authentication_keys: 'Email'))
        expect(page).to have_current_path(new_user_session_path)
      end
    end
  end
end
