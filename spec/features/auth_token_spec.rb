require 'rails_helper'

describe AuthToken do

  it 'generates an auth token', js: true do
    visit root_path
    click_link('Share a secret now...')
    expect(page).to have_content('All we need is your email, and theirs to get started')
    fill_in 'auth_token[email]', with: 'test@test.com'
    fill_in 'auth_token[recipient_email]', with: 'test@example.com'
    click_button 'Send TopSekr.it Token'

    auth_token = AuthToken.last
    expect(auth_token.hashed_token).to_not be_nil
    expect(auth_token.expire_at).to_not be_nil
    expect(auth_token.recipient_email).to eq('test@example.com')

    email = ActionMailer::Base.deliveries[0]
    expect(email.to).to eq(['test@test.com'])
    expect(email.from).to eq(['info@TopSekr.it'])
    expect(email.subject).to eq('Topsekrit authentication token')
    expect(email.text_part.to_s).to match(auth_token.hashed_token)
  end

  it 'provides a message if a token is invalid' do
    visit "/auth_tokens/ijustmadethisup"
    expect(page).to have_content('Token not found')
  end

  describe 'with an existing auth token saved to the database' do

    let!(:auth_token) {
      AuthToken.create(
        email: 'test@test.com',
        recipient_email: 'test@example.com'
      ).generate
    }

    before do
      auth_token.notify('https://www.example.com')
    end

    it 'finds the token and deletes it' do
      visit "/auth_tokens/#{auth_token.hashed_token}"
      expect(AuthToken.where(hashed_token: auth_token.hashed_token).count).to eq(0)
    end

    it 'redirects to the new secret page with the recipient\'s address filled in' do
      visit "/auth_tokens/#{auth_token.hashed_token}"
      expect(current_path).to eq("/secrets/new")
      expect(find('#secret_to_email').value).to eq('test@example.com')
    end

  end

end
