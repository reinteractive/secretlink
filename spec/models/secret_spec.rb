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

end