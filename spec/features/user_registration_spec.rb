require 'rails_helper'

describe 'User registration with email' do
  before { configure_authorisation(:open) }

  describe 'successful' do
    let(:email) { "user@secretlink.org" }

    before do
      visit root_path
      fill_in "user[email]", with: email
    end

    it 'creates an unconfirmed user' do
      expect { click_on "Register" }.to change { User.count }.by(1)

      user = User.last
      expect(user.email).to eq email
      expect(user.confirmation_token).to_not be_nil
      expect(user.confirmed_at).to be_nil
    end

    it 'shows a confirmation message' do
      click_on "Register"
      expect(page).to have_content I18n.t('devise.registrations.signed_up_but_unconfirmed')
    end

    it 'sends a confirmation email' do
      click_on "Register"

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

      expect { click_on "Register" }.to_not change { User.count }
    end
  end

  context 'system is limited/closed' do
    let!(:authorised_email) { 'authorised@secretlink.org' }
    let!(:unauthorised_email) { 'unauthorised@domain.com' }
    let!(:domain) { "secretlink.org" }

    before do
      configure_authorisation(:closed, domain)
      visit root_path
    end

    it 'allows emails with authorised domain' do
      fill_in "user[email]", with: authorised_email
      expect { click_on "Register" }.to change { User.count }.by(1)
    end

    it 'does not allow emails with unauthorised domains' do
      fill_in "user[email]", with: unauthorised_email
      expect { click_on "Register" }.to_not change { User.count }
      expect(page).to have_content I18n.t('field_errors.unauthorised')
    end
  end

end
