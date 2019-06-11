require 'rails_helper'

describe User do
  describe '#set_reset_password_token' do
    it 'returns the plaintext token' do
      potential_token = subject.send(:set_reset_password_token)
      potential_token_digest = Devise.token_generator.digest(subject, :reset_password_token, potential_token)
      actual_token_digest = subject.reset_password_token
      expect(potential_token_digest).to eql(actual_token_digest)
    end
  end
end
