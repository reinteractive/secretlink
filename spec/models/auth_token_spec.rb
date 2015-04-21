require 'rails_helper'

describe AuthToken do

  describe '#generate' do

    let!(:auth_token) { AuthToken.new(email: 'a@a.com') }

    before do
      auth_token.generate
      auth_token.reload
    end

    it 'adds a hashed token and an expiry time' do
      expect(auth_token.hashed_token).to_not be_nil
      expect(auth_token.expire_at).to_not be_nil
    end

  end

  describe '#notify' do

    let!(:auth_token) { AuthToken.new(email: 'b@b.com') }

    before do
      auth_token.generate
      auth_token.notify('https://example.com')
    end

    let(:email) { ActionMailer::Base.deliveries.last }

    it 'sends an email to the recipient with a link auth link' do
      expect(email.to).to eq(['b@b.com'])
      expect(email.body.to_s).to match(/https:\/\/example.com\/auth_tokens\/\S+/)
    end
  end

end
