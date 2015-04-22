require 'rails_helper'

describe SecretService do

  describe '#encrypt_secret' do

    let(:secret) { SecretService.encrypt_secret({secret: 'aBc123', to_email: 'a@a.com', from_email: 'b@b.com'}, 'https://example.com') }
    let(:invalid_secret) { SecretService.encrypt_secret({to_email: 'a@a.com', from_email: 'b@b.com'}, 'https://example.com') }

    it 'does not save the record if no secret is provided' do
      expect(invalid_secret.persisted?).to eq(false)
    end

    it 'saves an encrypted secret, salt, and iv' do
      expect(secret.encrypted_secret).to_not be_nil
      expect(secret.encrypted_secret_salt).to_not be_nil
      expect(secret.encrypted_secret_iv).to_not be_nil
    end

  end

  describe '#decrypt_secret' do

    let!(:secret) {
      SecretService.encrypt_secret({secret: 'aBc123', to_email: 'a@a.com', from_email: 'b@b.com', expire_at: Time.now + 7.days},
        'https://example.com')
    }
    let!(:retrieved_secret) { Secret.find(secret.id) }
    let(:secret_key) { ActionMailer::Base.deliveries.last.body.to_s.match(/https:\/\/example.com\/[\w-]*\/(\w*)\//)[1] }

    it 'raises an error if no key is provided' do
      expect{
        SecretService.decrypt_secret(retrieved_secret,nil)
      }.to raise_error(ArgumentError)
    end

    it 'raises an error if the incorrect key is provided, and does not delete the encrypted secret' do
      expect{
        SecretService.decrypt_secret(retrieved_secret,'derp')
      }.to raise_error(OpenSSL::Cipher::CipherError)
      expect(retrieved_secret.encrypted_secret).to_not be_nil
    end

    it 'returns the secret if the correct key is provided' do
      expect(SecretService.decrypt_secret(retrieved_secret, secret_key)).to eq('aBc123')
    end

    it 'deletes the encrypted secret when is has been accessed' do
      SecretService.decrypt_secret(retrieved_secret, secret_key)
      retrieved_secret.reload
      expect(retrieved_secret.encrypted_secret).to be_nil
    end

    it 'marks the secret as consumed when it is accessed' do
      SecretService.decrypt_secret(retrieved_secret, secret_key)
      retrieved_secret.reload
      expect(retrieved_secret.consumed_at).to_not be_nil
    end

  end

end