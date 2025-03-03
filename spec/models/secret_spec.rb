require 'rails_helper'

describe Secret do

  describe "#expired?" do

    let!(:secret) { SecretService.encrypt_new_secret({from_email: 'a@a.com', to_email: 'b@b.com',
      secret: 'cdefg', expire_at: Time.now - 7.days})
    }

    it 'is true if the expiry date is in the past' do
      expect(secret.expired?).to eq(true)
    end

    it 'is false if the expiry is in the future' do
      secret.update_attribute(:expire_at, Time.now + 2.days)
      expect(secret.expired?).to be(false)
    end

    it 'is false if the expiry date is nil' do
      secret.update_attribute(:expire_at, nil)
      expect(secret.expired?).to be(false)
    end

  end

  describe '#expire_at_within_limit' do

    let(:secret) { SecretService.encrypt_new_secret({from_email: 'a@a.com', to_email: 'b@b.com',
      secret: 'cdefg', expire_at: Time.now + 7.days})
    }

    before do
      allow(Rails.configuration).to receive(:topsekrit_authorisation_setting) { :open }
      allow(Rails.application.config).to receive(:topsekrit_maximum_expiry_time) { 6.days.to_i }
    end

    it 'does not allow secrets with a longer expiry than specified in the config' do
      expect(secret).to_not be_valid
      expect(secret.errors[:expire_at]).to eq([
        "Maximum expiry allowed is #{(Time.now + 6.days).strftime('%d %B %Y')}"
      ])
    end

    it 'allows secrets with a shorter expiry than specified in the config' do
      allow(Rails.application.config).to receive(:topsekrit_maximum_expiry_time) { 7.days.to_i }
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

    let(:secret) { SecretService.encrypt_new_secret({from_email: 'a@a.com', to_email: 'b@b.com',
      secret: 'cdefg', expire_at: Time.now + 7.days})
    }

    before do
      allow(Rails.configuration).to receive(:topsekrit_authorised_domain) { 'a.com' }
    end

    context 'the topsekrit_authorisation_setting is :open' do

      before do
        allow(Rails.configuration).to receive(:topsekrit_authorisation_setting) { :open }
      end

      it 'is valid' do
        expect(secret).to be_valid
      end

    end

    context 'the topsekrit_authorisation_setting is :closed' do

      before do
        allow(Rails.configuration).to receive(:topsekrit_authorisation_setting) { :closed }
      end

      it 'is valid if the to_email is from a.com' do
        secret.to_email = 'b@a.com'
        expect(secret).to be_valid
      end

      it 'is invalid if both the to_email domain is not from a.com' do
        secret.to_email = 'b@b.com'
        expect(secret).to be_invalid
      end

    end
  end
end
