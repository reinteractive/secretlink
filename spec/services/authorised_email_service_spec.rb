require 'rails_helper'

describe AuthorisedEmailService do
  describe '.closed_system?' do
    it 'returns true when system is closed' do
      configure_authorisation(:closed)
      expect(AuthorisedEmailService.closed_system?).to eq(true)
    end

    it 'returns false when system is open/limited' do
      configure_authorisation(:open)
      expect(AuthorisedEmailService.closed_system?).to eq(false)

      configure_authorisation(:limited)
      expect(AuthorisedEmailService.closed_system?).to eq(false)
    end
  end

  describe '.limited_system?' do
    it 'returns true when system is limited' do
      configure_authorisation(:limited)
      expect(AuthorisedEmailService.limited_system?).to eq(true)
    end

    it 'returns false when system is open/closed' do
      configure_authorisation(:open)
      expect(AuthorisedEmailService.limited_system?).to eq(false)

      configure_authorisation(:closed)
      expect(AuthorisedEmailService.limited_system?).to eq(false)
    end
  end

  describe '.open_system?' do
    it 'returns true when system is open' do
      configure_authorisation(:open)
      expect(AuthorisedEmailService.open_system?).to eq(true)
    end

    it 'returns false when system is limited/closed' do
      configure_authorisation(:limited)
      expect(AuthorisedEmailService.open_system?).to eq(false)

      configure_authorisation(:closed)
      expect(AuthorisedEmailService.open_system?).to eq(false)
    end
  end

  describe '.closed_or_limited_system?' do
    it 'returns true when system is closed/limited' do
      configure_authorisation(:limited)
      expect(AuthorisedEmailService.closed_or_limited_system?).to eq(true)

      configure_authorisation(:closed)
      expect(AuthorisedEmailService.closed_or_limited_system?).to eq(true)
    end

    it 'returns false when system is open' do
      configure_authorisation(:open)
      expect(AuthorisedEmailService.closed_or_limited_system?).to eq(false)
    end
  end

  describe '.authorised_to_register?' do
    let!(:domain) { 'example.com' }
    let!(:authorised_email) { 'authorised@example.com' }
    let!(:unauthorised_email) { 'unauthorised@domain.com' }

    context 'system is closed' do
      before { configure_authorisation(:closed, domain) }

      it 'returns true if email belongs to authorised domain' do
        expect(AuthorisedEmailService.authorised_to_register?(authorised_email)).to eq(true)
      end

      it 'returns false if email does not belong authorised domain' do
        expect(AuthorisedEmailService.authorised_to_register?(unauthorised_email)).to eq(false)
      end
    end

    context 'system is limited' do
      before { configure_authorisation(:limited, domain) }

      it 'returns true if email belongs to authorised domain' do
        expect(AuthorisedEmailService.authorised_to_register?(authorised_email)).to eq(true)
      end

      it 'returns false if email does not belong authorised domain' do
        expect(AuthorisedEmailService.authorised_to_register?(unauthorised_email)).to eq(false)
      end
    end

    context 'system is open' do
      before { configure_authorisation(:open, domain) }

      it 'returns true if email belongs to authorised domain' do
        expect(AuthorisedEmailService.authorised_to_register?(authorised_email)).to eq(true)
      end

      it 'returns true if email does not belong authorised domain' do
        expect(AuthorisedEmailService.authorised_to_register?(unauthorised_email)).to eq(true)
      end
    end
  end

  describe '.email_domain_matches?' do
    let!(:domain) { 'example.com' }
    let!(:authorised_email) { 'authorised@example.com' }
    let!(:unauthorised_email) { 'unauthorised@domain.com' }

    before { configure_authorisation(:open, domain) }

    it 'returns matched emails for authorised domain' do
      matches = AuthorisedEmailService.email_domain_matches?(authorised_email)
      expect(matches).to be_truthy
    end

    it 'returns matched emails for authorised domain' do
      matches = AuthorisedEmailService.email_domain_matches?(unauthorised_email)
      expect(matches).to be_falsey
    end
  end

  describe '.email_domain_does_not_match?' do
    let!(:domain) { 'example.com' }
    let!(:authorised_email) { 'authorised@example.com' }
    let!(:unauthorised_email) { 'unauthorised@domain.com' }

    before { configure_authorisation(:open, domain) }

    it 'returns true if email does not belong to authorised domain' do
      matches = AuthorisedEmailService.email_domain_does_not_match?(unauthorised_email)
      expect(matches).to be true
    end

    it 'returns false if email belongs to authorised domain' do
      matches = AuthorisedEmailService.email_domain_does_not_match?(authorised_email)
      expect(matches).to be false
    end
  end
end
