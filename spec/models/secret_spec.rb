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

end