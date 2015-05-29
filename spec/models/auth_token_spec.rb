require 'rails_helper'

describe AuthToken do

  before do
    allow(Rails.configuration).to receive(:snapsecret_authorisation_setting) { :open }
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
      expect(email.text_part.to_s).to match(/https:\/\/example.com\/auth_tokens\/\S+/)
    end
  end

  describe '#email_domain_authorised' do

    let(:auth_token) { AuthToken.new(email: 'c@c.com') }

    it 'is valid if the snapsecret_authorisation_setting is :open' do
      allow(Rails.configuration).to receive(:snapsecret_authorisation_setting) { :open }
      expect(auth_token).to be_valid
    end

    it 'is valid if the snapsecret_authorisation_setting is :limited' do
      allow(Rails.configuration).to receive(:snapsecret_authorisation_setting) { :limited }
      expect(auth_token).to be_valid
    end

    context 'the snapsecret_authorised_domains includes the email domain' do

      before do
        allow(Rails.configuration).to receive(:snapsecret_authorised_domain) { 'c.com' }
      end

      it 'is valid if the snapsecret_authorisation_setting is :closed' do
        allow(Rails.configuration).to receive(:snapsecret_authorisation_setting) { :closed }
        expect(auth_token).to be_valid
      end

    end

    context 'the snapsecret_authorised_domains does not include the email domain' do

      before do
        allow(Rails.configuration).to receive(:snapsecret_authorised_domain) { 'd.com' }
      end

      it 'is invalid if the snapsecret_authorisation_setting is :closed' do
        allow(Rails.configuration).to receive(:snapsecret_authorisation_setting) { :closed }
        expect(auth_token).to_not be_valid
      end

    end

  end

end
