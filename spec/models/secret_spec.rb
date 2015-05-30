require 'rails_helper'

describe Secret do

  describe "#expired?" do

    let!(:secret) { SecretService.encrypt_secret({from_email: 'a@a.com', to_email: 'b@b.com',
      secret: 'cdefg', expire_at: Time.now - 7.days}, 'https://example.com')
    }

    it 'is true if the expiry date is in the past' do
      expect(secret.expired?).to eq(true)
    end

    it 'is false if the expiry is in the future' do
      secret.update_attributes(expire_at: Time.now + 2.days)
      expect(secret.expired?).to be(false)
    end

    it 'is false if the expiry date is nil' do
      secret.update_attributes(expire_at: nil)
      expect(secret.expired?).to be(false)
    end

  end

  describe '#expire_at_within_limit' do

    let(:secret) { SecretService.encrypt_secret({from_email: 'a@a.com', to_email: 'b@b.com',
      secret: 'cdefg', expire_at: Time.now + 7.days}, 'https://example.com')
    }

    before do
      allow(Rails.application.config).to receive(:snapsecret_maximum_expiry_time) { 6.days.to_i }
    end

    it 'does not allow secrets with a longer expiry than specified in the config' do
      expect(secret).to_not be_valid
      expect(secret.errors[:expire_at]).to eq([
        "Maximum expiry allowed is #{(Time.now + 6.days).strftime('%d %B %Y')}"
      ])
    end

    it 'allows secrets with a shorter expiry than specified in the config' do
      allow(Rails.application.config).to receive(:snapsecret_maximum_expiry_time) { 7.days.to_i }
      expect(secret).to be_valid
    end

    it 'does not allow secrets with no expiry with an expiry specified in the config' do
      secret.expire_at = nil
      expect(secret).to_not be_valid
      expect(secret.errors[:expire_at]).to eq([
        "Maximum expiry allowed is #{(Time.now + 6.days).strftime('%d %B %Y')}"
      ])
    end

  end

  describe 'email_domain_authorised' do

    let(:secret) { SecretService.encrypt_secret({from_email: 'a@a.com', to_email: 'b@b.com',
      secret: 'cdefg', expire_at: Time.now + 7.days}, 'https://example.com')
    }

    before do
      allow(Rails.configuration).to receive(:snapsecret_authorised_domain) { 'a.com' }
    end

    context 'the snapsecret_authorisation_setting is :open' do

      before do
        allow(Rails.configuration).to receive(:snapsecret_authorisation_setting) { 'open' }
      end

      it 'is valid' do
        expect(secret).to be_valid
      end

    end

    context 'the snapsecret_authorisation_setting is :closed' do

      before do
        allow(Rails.configuration).to receive(:snapsecret_authorisation_setting) { 'closed' }
      end

      it 'is valid if the to_email and from_email domains are both a.com' do
        secret.from_email = 'a@a.com'
        secret.to_email = 'b@a.com'
        expect(secret).to be_valid
      end

      it 'is invalid if the to_email domain is not a.com' do
        secret.from_email = 'a@a.com'
        secret.to_email = 'b@b.com'
        expect(secret).to be_invalid
      end

      it 'is invalid if the from_email domain is not a.com' do
        secret.from_email = 'b@b.com'
        secret.to_email = 'b@a.com'
        expect(secret).to be_invalid
      end

    end

    context 'the snapsecret_authorisation_setting is :limited' do

      before do
        allow(Rails.configuration).to receive(:snapsecret_authorisation_setting) { 'limited' }
      end

      it 'is valid if the to_email or from_email domains are from a.com' do
        secret.from_email = 'a@a.com'
        secret.to_email = 'b@b.com'
        expect(secret).to be_valid
        secret.to_email = 'a@a.com'
        secret.from_email = 'b@b.com'
        expect(secret).to be_valid
      end

      it 'is invalid if both the to_email and from_email domains are not from a.com' do
        secret.from_email = 'a@b.com'
        secret.to_email = 'b@b.com'
        expect(secret).to be_invalid
      end

    end

  end

end