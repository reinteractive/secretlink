require 'rails_helper'

describe 'Two Factor Auth Setup', js: true do
  describe 'enable' do
    let!(:user) { create :user, :with_secret }

    before do
      login_as(user)
      visit edit_two_factor_auth_path
    end

    context 'successful' do
      it 'enable users two factor authentication' do
        expect(page).to_not have_css("img.qrcode")

        check('Enable two factor authentication')
        expect(page).to have_css("img.qrcode")
        fill_in 'user[otp_attempt]', with: user.current_otp
        fill_in 'user[current_password]', with: 'password'
        click_on 'Save Settings'

        expect(page).to have_content I18n.t('two_factor.update_success', verb: 'enabled')
        expect(user.reload.otp_required_for_login).to be true
      end
    end

    context 'failed' do
      it 'does not enable two factor authentication' do
        expect(page).to_not have_css("img.qrcode")

        check('Enable two factor authentication')
        expect(page).to have_css("img.qrcode")
        fill_in 'user[otp_attempt]', with: user.current_otp
        fill_in 'user[current_password]', with: 'wrong password'
        click_on 'Save Settings'

        expect(page).to have_content I18n.t('two_factor.update_failed')
        expect(user.reload.otp_required_for_login).to be false
      end
    end
  end

  describe 'disable' do
    let!(:user) { create :user, :otp_enabled, :with_secret }

    before do
      login_as(user)
      visit edit_two_factor_auth_path
    end

    context 'successful' do
      it 'disables users two factor authentication' do
        expect(page).to have_content('Use the form to connect a new device')

        uncheck('Enable two factor authentication')
        fill_in 'user[current_password]', with: 'password'
        click_on 'Save Settings'

        expect(page).to have_content I18n.t('two_factor.update_success', verb: 'disabled')
        expect(user.reload.otp_required_for_login).to be false
      end
    end

    context 'failed' do
      it 'does not enable users two factor authentication' do
        expect(page).to have_content('Use the form to connect a new device')

        uncheck('Enable two factor authentication')
        fill_in 'user[current_password]', with: 'wrong password'
        click_on 'Save Settings'

        expect(page).to have_content I18n.t('two_factor.update_failed')
        expect(user.reload.otp_required_for_login).to be true
      end
    end
  end
end
