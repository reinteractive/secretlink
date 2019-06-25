require 'rails_helper'

describe 'oauth via google' do

  before do
    OmniAuth.config.test_mode = true
  end

  after do
    OmniAuth.config.mock_auth[:google_oauth2] = nil
  end

  describe 'successful auth' do

    before do
      OmniAuth.config.add_mock(:google_oauth2,
        info: { first_name: 'John', last_name: 'Smith', email: 'a@google.com' }
      )
    end

    it 'signs me in' do
      visit root_path
      find('a#oauth-google').click
      expect(page).to have_content('Authenticated as "a@google.com" via google')
    end

  end

  describe 'unsuccessful auth' do

    let!(:previous_logger) { OmniAuth.config.logger }

    before do
      OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
      OmniAuth.config.logger = Logger.new("/dev/null")
    end

    it 'does not sign me in' do
      visit root_path
      find('a#oauth-google').click
      expect(page).to have_content('Authentication failed')
    end

    after do
      OmniAuth.config.logger = previous_logger
    end

  end

end
