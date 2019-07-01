require 'rails_helper'

describe 'oauth via google' do

  before { OmniAuth.config.test_mode = true }
  after { OmniAuth.config.mock_auth[:google_oauth2] = nil }

  let!(:info) { { first_name: 'John', last_name: 'Smith', email: 'a@google.com' } }

  describe 'successful auth' do
    before do
      OmniAuth.config.add_mock(:google_oauth2, info: info)

      visit root_path
      find('a#oauth-google').click
    end

    it 'creates a confirmed user without password' do
      user = User.find_by(email: info[:email])

      expect(user).to_not be_nil
      expect(user.encrypted_password).to be_blank
      expect(user.confirmed_at).to_not be_nil
    end

    it 'redirects to password update page' do
      expect(page).to have_content I18n.t('devise.confirmations.confirmed')
      expect(page).to have_content 'Set your password'
    end
  end

  describe 'user is already in the system but unconfirmed' do
    let!(:user) { create :user, :unconfirmed, email: info[:email] }

    before do
      OmniAuth.config.add_mock(:google_oauth2, info: info)
      visit root_path
      find('a#oauth-google').click
    end

    it 'confirms the user' do
      expect(user.reload.confirmed_at).to_not be_nil
    end

    it 'redirects user to enter password' do
      expect(page).to have_content('Set your password')

      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
      click_on 'Set my password'

      expect(page).to have_content I18n.t('welcome')
      expect(page).to have_content 'Create a new secret to send'
      expect(user.reload.encrypted_password).to_not be_blank
    end
  end

  describe 'user is already in the system but failed to set password' do
    let!(:user) { create :user, :confirmed_without_password, email: info[:email] }

    before do
      OmniAuth.config.add_mock(:google_oauth2, info: info)
      visit root_path
      find('a#oauth-google').click
    end

    it 'redirects user to enter password' do
      expect(page).to have_content('Set your password')

      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
      click_on 'Set my password'

      expect(page).to have_content I18n.t('welcome')
      expect(page).to have_content 'Create a new secret to send'
      expect(user.reload.encrypted_password).to_not be_blank
    end
  end

  describe 'unsuccessful auth' do
    let!(:previous_logger) { OmniAuth.config.logger }

    context 'user is already registered' do
      let!(:existing_user) { create :user, email: info[:email] }
      before { OmniAuth.config.add_mock(:google_oauth2, info: info) }

      it 'redirects to login page' do
        visit root_path
        find('a#oauth-google').click

        expect(page).to have_content I18n.t('oauth.already_registered')
        expect(page).to have_current_path(user_session_path)
      end
    end

    context 'google failed to authenticate' do
      before do
        OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
        OmniAuth.config.logger = Logger.new("/dev/null")
      end

      it 'does not register the user' do
        visit root_path
        find('a#oauth-google').click

        expect(User.count).to eq 0
        expect(page).to have_content I18n.t('oauth.failed')
      end

      after { OmniAuth.config.logger = previous_logger }
    end

    context 'system is closed and user is not authorised' do
      before do
        configure_authorisation(:closed, 'strict.com')
        OmniAuth.config.add_mock(:google_oauth2, info: info)
      end

      it 'does not register the user' do
        visit root_path
        find('a#oauth-google').click

        expect(User.count).to eq 0
        expect(page).to have_content I18n.t('field_errors.unauthorised')
      end
    end

  end
end
