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

  describe '.with_email_and_access_key' do
    let(:from_email) { 'sender1@example.com' }
    let(:to_email) { 'to@example.com' }
    let(:access_key) { 'abc123' }
    let(:secret_info) { 'my secret info' }
    let!(:matching_secret) do
      SecretService.encrypt_new_secret( { secret: secret_info,
                                          to_email: to_email,
                                          from_email: from_email,
                                          access_key: access_key,
                                          expire_at: Time.now + 7.days})
    end

    let!(:different_email) do
      SecretService.encrypt_new_secret( { secret: secret_info,
                                          to_email: to_email,
                                          from_email: 'diffsender@example.com',
                                          access_key: access_key,
                                          expire_at: Time.now + 7.days})
    end
    let!(:different_key) do
      SecretService.encrypt_new_secret( { secret: secret_info,
                                          to_email: to_email,
                                          from_email: from_email,
                                          access_key: 'another key',
                                          expire_at: Time.now + 7.days})
    end

    it 'returns secrets matching both email and access key' do
      result = described_class.with_email_and_access_key(from_email, access_key)

      expect(result).to include(matching_secret)
      expect(result).not_to include(different_email)
      expect(result).not_to include(different_key)
      expect(result.count).to eq(1)
    end
  end

  describe '.expire_at_hint' do
    context 'when maximum expiry time is configured' do
      before do
        allow(Rails.application.config)
          .to receive(:topsekrit_maximum_expiry_time)
          .and_return(7.days)
      end

      it 'returns a date range string from tomorrow to maximum allowed date' do
        tomorrow = (Date.today + 1).strftime('%d %B %Y')
        max_date = (Time.now + 7.days).strftime('%d %B %Y')
        expected_hint = "#{tomorrow} - #{max_date}"

        expect(Secret.expire_at_hint).to eq(expected_hint)
      end
    end

    context 'when maximum expiry time is not configured' do
      before do
        allow(Rails.application.config)
          .to receive(:topsekrit_maximum_expiry_time)
          .and_return(nil)
      end

      it 'returns nil' do
        expect(Secret.expire_at_hint).to be_nil
      end
    end
  end

  describe 'with attached file' do
    let(:secret) do
      SecretService.encrypt_new_secret( { secret: 'secret_info',
                                          to_email: 'to_email@example.com',
                                          from_email: 'from_email@example.com',
                                          expire_at: Time.now + 7.days})
    end
    let(:test_file) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'files', 'test.txt'), 'text/plain') }

    before do
      # Ensure the fixture directory exists
      FileUtils.mkdir_p(Rails.root.join('spec', 'fixtures', 'files'))
      # Create a test file
      File.write(Rails.root.join('spec', 'fixtures', 'files', 'test.txt'), 'test content')
    end

    it 'can attach a file' do
      secret.secret_file = test_file
      expect(secret.secret_file).to be_present
      expect(secret.secret_file.store_dir).to eq("uploads/secret/secret_file/#{secret.id}")
    end

    after do
      # Clean up the test file
      FileUtils.rm_rf(Rails.root.join('spec', 'fixtures', 'files'))
    end
  end
end
