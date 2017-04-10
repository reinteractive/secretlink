require 'rails_helper'

describe AuthToken do

  let(:from_email) { "from@example.com" }
  let(:from_domain) { "example.com" }

  before do
    allow(Rails.configuration).to receive(:topsekrit_authorisation_setting) { :open }
  end

  describe '#set_defaults' do

    let!(:auth_token) { AuthToken.new(email: from_email) }

    before(:each) do
      auth_token.valid?
    end

    it 'adds a hashed token and an expiry time' do
      expect(auth_token.hashed_token).to_not be_nil
      expect(auth_token.expire_at).to_not be_nil
    end

  end

  describe '#notify' do

    let!(:auth_token) { AuthToken.create!(email: from_email) }

    before do
      auth_token.notify
    end

    let(:email) { ActionMailer::Base.deliveries.last }

    it 'sends an email to the recipient with a link auth link' do
      expect(email.to).to eq([from_email])
      expect(email.to_s).to match(/http:\/\/localhost:3000\/auth_tokens\/\S+/)
    end
  end

  describe '#email_domain_authorised' do

    let(:auth_token) { AuthToken.new(email: from_email) }

    it 'is valid if the topsekrit_authorisation_setting is :open' do
      allow(Rails.configuration).to \
        receive(:topsekrit_authorisation_setting).and_return(:open)
      expect(auth_token).to be_valid
    end

    context 'if the topsekrit_authorisation_setting is :limited' do
      before(:each) do
            allow(Rails.configuration).to \
        receive(:topsekrit_authorisation_setting).and_return(:limited)
      end

      context 'and the topsekrit_authorised_domains includes the email domain' do

        before do
          allow(Rails.configuration).to \
            receive(:topsekrit_authorised_domain).and_return(from_domain)
        end

        it 'is valid' do
          expect(auth_token).to be_valid
        end

      end

      context 'and the topsekrit_authorised_domains does not include the email domain' do

        before do
          allow(Rails.configuration).to \
            receive(:topsekrit_authorised_domain).and_return("#{from_domain}.au")
        end

        it 'is invalid' do
          expect(auth_token).to_not be_valid
        end

      end
    end
  end
end
