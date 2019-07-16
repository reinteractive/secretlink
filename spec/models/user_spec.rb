require 'rails_helper'

describe User do
  describe 'hooks' do
    it 'creates user settings after creation' do
      user = User.create(email: 'user@test.com')
      expect(user.settings).to_not be nil
    end
  end

  describe 'validations' do
    let!(:domain) { 'reinteractive.net' }
    let!(:authorised_user) { build :user, email: 'authorised@reinteractive.net' }
    let!(:unauthorised_user) { build :user, email: 'unauthorised@example.com' }

    context 'system is closed' do
      before { configure_authorisation(:closed, domain) }

      it 'validates if email is allowed for the system' do
        expect(authorised_user).to be_valid
        expect(unauthorised_user).to_not be_valid
        expect(unauthorised_user.errors.messages[:email]).to include I18n.t('field_errors.unauthorised')
      end
    end

    context 'system is limited' do
      before { configure_authorisation(:limited, domain) }

      it 'validates if email is allowed for the system' do
        expect(authorised_user).to be_valid
        expect(unauthorised_user).to_not be_valid
        expect(unauthorised_user.errors.messages[:email]).to include I18n.t('field_errors.unauthorised')
      end
    end

    context 'system is open' do
      before { configure_authorisation(:open, domain) }

      it 'does not validate if email is allowed for the system' do
        expect(authorised_user).to be_valid
        expect(unauthorised_user).to be_valid
      end
    end
  end

  describe '#set_reset_password_token' do
    it 'returns the plaintext token' do
      potential_token = subject.send(:set_reset_password_token)
      potential_token_digest = Devise.token_generator.digest(subject, :reset_password_token, potential_token)
      actual_token_digest = subject.reset_password_token
      expect(potential_token_digest).to eql(actual_token_digest)
    end
  end
end
