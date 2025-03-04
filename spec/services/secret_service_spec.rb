require "rails_helper"

describe SecretService do

  let(:to_email) { "to@example.com" }
  let(:from_email) { "from@example.com" }
  let(:secret_info) { "My Secret Info" }

  before do
    allow(Rails.configuration).to receive(:topsekrit_authorisation_setting) { :open }
  end

  describe "#encrypt_new_secret" do

    let(:secret) {
      SecretService.encrypt_new_secret( { secret: secret_info,
                                          to_email: to_email,
                                          from_email: from_email }) }
    let(:invalid_secret) {
      SecretService.encrypt_new_secret( { to_email: to_email,
                                          from_email: from_email }) }

    it "does not save the record if no secret is provided" do
      expect(invalid_secret.persisted?).to eq(false)
    end

    it "saves an encrypted secret, salt, and iv" do
      expect(secret.encrypted_secret).to_not be_nil
      expect(secret.encrypted_secret_salt).to_not be_nil
      expect(secret.encrypted_secret_iv).to_not be_nil
    end

  end

  describe "#decrypt_secret!" do

    let!(:secret) {
      SecretService.encrypt_new_secret( { secret: secret_info,
                                          to_email: to_email,
                                          from_email: from_email,
                                          expire_at: Time.now + 7.days})
    }
    let!(:retrieved_secret) { Secret.find(secret.id) }
    let(:secret_key) { ActionMailer::Base.deliveries.last.to_s.match(/\?key=(\w+)/)[1] }

    it "raises an error if no key is provided" do
      expect{
        SecretService.decrypt_secret!(retrieved_secret,nil)
      }.to raise_error(ArgumentError)
    end

    it "raises an error if the incorrect key is provided, and does not delete the encrypted secret" do
      expect{
        key = "needs-to-be-at-least-32-bytes-long"
        SecretService.decrypt_secret!(retrieved_secret, key)
      }.to raise_error(OpenSSL::Cipher::CipherError)
      expect(retrieved_secret.encrypted_secret).to_not be_nil
    end

    it "returns the secret if the correct key is provided" do
      expect(SecretService.decrypt_secret!(retrieved_secret, secret_key)).to eq(secret_info)
    end

    it "deletes the encrypted secret when is has been accessed" do
      SecretService.decrypt_secret!(retrieved_secret, secret_key)
      retrieved_secret.reload
      expect(retrieved_secret.encrypted_secret).to be_nil
    end

    it "marks the secret as consumed when it is accessed" do
      SecretService.decrypt_secret!(retrieved_secret, secret_key)
      retrieved_secret.reload
      expect(retrieved_secret.consumed_at).to_not be_nil
    end

  end

  describe '.correct_key?' do
    let!(:secret) {
      SecretService.encrypt_new_secret( { secret: secret_info,
                                          to_email: to_email,
                                          from_email: from_email,
                                          expire_at: Time.now + 7.days})
    }
    let(:password) { secret.secret_key }

    context 'when the password is correct' do
      it 'returns true' do
        expect(SecretService.correct_key?(secret, password)).to be true
      end
    end

    context 'when decryption raises OpenSSL::Cipher::CipherError' do
      before do
        allow(secret).to receive(:secret).and_raise(OpenSSL::Cipher::CipherError)
      end

      it 'returns false' do
        expect(SecretService.correct_key?(secret, 'any_password')).to be false
      end
    end

    context 'when decryption raises ArgumentError' do
      before do
        allow(secret).to receive(:secret).and_raise(ArgumentError)
      end

      it 'returns false' do
        expect(SecretService.correct_key?(secret, 'any_password')).to be false
      end
    end
  end
end
