require 'rails_helper'

describe AuthToken do

  it 'generates an auth token' do
    visit root_url
    expect(page).to have_content('Enter your email address')
    fill_in 'Email', with: 'test@test.com'
    click_button 'Send'

    auth_token = AuthToken.last
    expect(auth_token.hashed_token).to_not be_nil
    expect(auth_token.expire_at).to_not be_nil

    email = ActionMailer::Base.deliveries[0]
    expect(email.to).to eq(['test@test.com'])
    expect(email.subject).to eq('SnapSecret authentication token')
    expect(email.text_part.to_s).to match(auth_token.hashed_token)
  end

  it 'provides a message if a token is invalid' do
    visit "/auth_tokens/ijustmadethisup"
    expect(page).to have_content('Token not found')
  end

  describe 'with an existing auth token saved to the database' do

    let!(:auth_token) { AuthToken.create(email: 'test@test.com').generate }

    before do
      auth_token.notify('https://www.example.com')
    end

    it 'finds the token and deletes it' do
      visit "/auth_tokens/#{auth_token.hashed_token}"
      expect(AuthToken.where(hashed_token: auth_token.hashed_token).count).to eq(0)
    end

    it 'redirects to the new secret page' do
      visit "/auth_tokens/#{auth_token.hashed_token}"
      expect(current_path).to eq("/secrets/new")
    end

  end

end