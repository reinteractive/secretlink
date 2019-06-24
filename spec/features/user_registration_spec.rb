require 'rails_helper'

describe 'User registration with email' do
  describe 'successful' do
    let(:email) { "user@secretlink.org" }

    it 'creates an unconfirmed user' do
      visit root_path

      fill_in "user[email]", with: email
      expect { click_button "Register" }.to change { User.count }.by(1)

      user = User.last
      expect(user.email).to eq email
      expect(user.confirmation_token).to_not be_nil
      expect(user.confirmed_at).to be_nil
    end

    it 'shows a confirmation message' do
      visit root_path

      fill_in "user[email]", with: email
      click_button "Register"
      expect(page).to have_content I18n.t('devise.registrations.signed_up_but_unconfirmed')
    end

    it 'sends a confirmation email' do
      visit root_path

      fill_in "user[email]", with: email
      click_button "Register"

      mail = ActionMailer::Base.deliveries.last

      expect(mail.to).to match_array([email])
      expect(mail.subject).to eq  "Confirmation instructions"
    end
  end

  describe 'unsuccessful' do
    let (:invalid_email) { "invalidemail" }

    it 'does not create a user' do
      visit root_path

      expect(page).to have_content("Register")
      fill_in "user[email]", with: invalid_email

      expect { click_button "Register" }.to_not change { User.count }
    end
  end
end
