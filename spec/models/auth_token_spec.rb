require 'rails_helper'

describe AuthToken do

  before do
    allow(Rails.configuration).to receive(:snapsecret_domains_allowed_to_create_secrets) { nil }
  end

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

  describe '#email_domain_authorised' do

    let(:auth_token) { AuthToken.new(email: 'c@c.com') }

    it 'allows auth tokens to be created when the config setting is nil' do
      allow(Rails.configuration).to receive(:snapsecret_domains_allowed_to_create_secrets) { nil }
      expect(auth_token).to be_valid
    end

    it 'allows auth tokens to be created when the email domain matches the config setting' do
      allow(Rails.configuration).to receive(:snapsecret_domains_allowed_to_create_secrets) { 'c.com' }
      expect(auth_token).to be_valid
    end

    it 'allows auth tokens to be created when the email domain is one of those provided in the config setting' do
      allow(Rails.configuration).to receive(:snapsecret_domains_allowed_to_create_secrets) { ['b.com', 'c.com'] }
      expect(auth_token).to be_valid
    end

    it 'does not allow auth tokens to be created when the email domain does not match the config setting' do
      allow(Rails.configuration).to receive(:snapsecret_domains_allowed_to_create_secrets) { 'd.com' }
      expect(auth_token).to_not be_valid
      expect(auth_token.errors[:email]).to eq(['Email addresses @c.com are not authorised to create secrets'])
    end

    it 'does not allow auth tokens to be created when the email domain is not one of those provided in the config setting' do
      allow(Rails.configuration).to receive(:snapsecret_domains_allowed_to_create_secrets) { ['d.com', 'e.com'] }
      expect(auth_token).to_not be_valid
      expect(auth_token.errors[:email]).to eq(['Email addresses @c.com are not authorised to create secrets'])
    end

  end

end
