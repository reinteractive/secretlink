require 'rails_helper'

describe Secret do

  describe "on an open system" do
    before do
      allow(Rails.configuration).to receive(:topsekrit_authorisation_setting) { :open }
    end

    describe 'creating a secret' do

      let!(:auth_token) { AuthToken.create(email: 'test@test.com').generate }
      let(:secret) { Secret.last }

      before do
        auth_token.notify('https://www.example.com')
        visit auth_token_path(auth_token.hashed_token)
        fill_in 'Title', with: 'Super Secret'
        fill_in "Recipient's email addres", with: 'example@example.com'
        fill_in "Secret", with: 'AbC123'
        fill_in 'Comments', with: 'Some super secret info'
        fill_in 'Expire at', with: (Time.current + 1.day).strftime('%d %B, %Y')
        click_button 'Create'
        expect(page).to have_content('The secret has been encrypted and an email sent to the recipient')
      end

      it 'allows a secret to be created' do
        expect(secret.title).to eq('Super Secret')
        expect(secret.from_email).to eq('test@test.com')
        expect(secret.to_email).to eq('example@example.com')
        expect(secret.comments).to eq('Some super secret info')
        expect(secret.expire_at).to eq((Date.current + 1).strftime('%Y-%m-%d'))
        expect(secret.secret_file).to_not be_nil
      end

      it 'sends an email to the recipient' do
        email = ActionMailer::Base.deliveries.last
        expect(email.to).to eq(['example@example.com'])
        expect(email.subject).to eq("Topsekrit ID#{Secret.last.id}: A secret has been shared with you")
        expect(email.text_part.to_s).to match("This link will show you the secret:")
        expect(email.text_part.to_s).to match("/#{secret.uuid}/.+/.+")
      end

      it 'encrypts the secret in the db' do
        expect(secret.encrypted_secret).to_not be_nil
        expect(secret.encrypted_secret).to_not eq('AbC123')
        expect(secret.encrypted_secret_salt).to_not be_nil
        expect(secret.encrypted_secret_iv).to_not be_nil
        expect(secret.secret_key).to be_nil
      end

      it 'allows oauth to authenticate when creating a secret'

    end

    describe 'accessing a secret' do

      let!(:secret) { SecretService.encrypt_secret({from_email: 'a@a.com', to_email: 'b@b.com',
        secret: 'cdefg', expire_at: Time.current + 7.days}, 'https://example.com')
      }
      let!(:link_to_secret) { ActionMailer::Base.deliveries.last.text_part.to_s.match(/http[\S]+/) }

      before do
        visit link_to_secret
      end

      it 'provides a link to show the secret but does not delete it yet' do
        expect(page.html).to match('Click here to show the secret')
        expect(Secret.find(secret.id).encrypted_secret).to_not be_nil
      end

      it 'retrieves and decrypts the secret' do
        click_button 'Click here to show the secret'
        expect(page).to have_content('cdefg')
      end

      it 'works with attachments'

      it 'deletes the secret after it has been accessed' do
        click_button 'Click here to show the secret'
        expect(page).to have_content('cdefg')
        secret.reload
        expect(secret.encrypted_secret).to be_nil
        expect(secret.consumed_at).to_not be_nil
      end

      it 'deletes an attachment after it has been accessed'

      it 'notifies the creator of the secret that it has been accessed and deleted' do
        click_button 'Click here to show the secret'
        expect(page).to have_content('cdefg')
        email = ActionMailer::Base.deliveries.last
        expect(email.to).to eq(['a@a.com'])
        expect(email.subject).to eq("Secret ID#{Secret.last.id} consumed on topsekrit")
        expect(email.text_part.to_s).to match('b@b.com')
        expect(email.text_part.to_s).to match('The encrypted information has now been deleted from the database')
      end

      it 'does not notify the creator if they selected not to be notified'
        # maybe add this in as a checkbox?

    end

    describe 'trying to access an expired secret' do

      let!(:secret) { SecretService.encrypt_secret({
        from_email: 'a@a.com', to_email: 'b@b.com', secret: 'cdefg', expire_at: Time.now - 1}, 'https://example.com')
      }
      let!(:link_to_secret) { ActionMailer::Base.deliveries.last.text_part.to_s.match(/http[\S]+/)}

      # there should also be a worker that cleans expired secrets up,
      # but even if that isn't working the secret shouldn't be accessible
      it 'informs the secret is expired and ensures the encrypted secret is removed' do
        visit link_to_secret
        expect(page).to have_content('That secret has expired')
        expect(page).to_not have_content('cdefg')
      end

    end
  end

  describe "on a closed system" do

    describe 'validations' do

      let!(:auth_token) { AuthToken.create(email: 'test@test.com').generate }

      before do
        allow(Rails.configuration).to receive(:topsekrit_authorisation_setting) { :closed }
        allow(Rails.configuration).to receive(:topsekrit_authorised_domain) { 'test.com' }
        auth_token.notify('https://www.example.com')
        visit auth_token_path(auth_token.hashed_token)
      end

      it 'provides validation of missing/incorrect info in the form' do
        click_button 'Create'
        expect(page).to have_content("Please enter the recipient's email address")
        expect(page).to have_content("Please enter a secret to share with the recipient")
      end

      it 'advises of restriction on email addresses that can create secrets' do
        fill_in "Recipient's email address", with: 'b@b.com'
        click_button 'Create'
        expect(page).to have_content('Secrets can only be shared with emails @test.com')
      end

    end
  end

end
