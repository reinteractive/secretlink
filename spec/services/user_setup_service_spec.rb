require 'rails_helper'

describe UserSetupService do
  let!(:user) { create :user, :unconfirmed }
  let!(:token) { issue_reset_password_token!(user) }

  before do
    user.reload
  end

  describe '#initialize' do
    let!(:setup_service) { UserSetupService.new(token, TwoFactorService) }

    it 'sets the user' do
      expect(setup_service.user).to eq user
    end

    it 'initializes a TwoFactorService' do
      expect(setup_service.tfa_service).to be_a TwoFactorService
    end
  end

  describe '#run' do
    let!(:tfa_service) { TwoFactorService.new(user) }
    let!(:secret) { tfa_service.issue_otp_secret }
    let!(:otp_user) { tfa_service.user }
    let!(:setup_service) { UserSetupService.new(token, TwoFactorService) }

    context 'successful without otp' do
      let!(:password_params) { {password: 'password', password_confirmation: 'password', reset_password_token: token} }
      let!(:tfa_params) { {otp_required_for_login: '0'} }

      it 'returns true' do
        result = setup_service.run(password_params, tfa_params)
        expect(result).to be true
      end

      it 'updates the users password' do
        expect(user.encrypted_password).to be_blank

        setup_service.run(password_params, tfa_params)
        expect(user.reload.encrypted_password).to_not be_blank
      end
    end

    context 'successful with otp' do
      let!(:password_params) { {password: 'password', password_confirmation: 'password', reset_password_token: token} }
      let!(:tfa_params) { {otp_required_for_login: '1', otp_secret: secret, otp_attempt: otp_user.current_otp} }

      it 'returns true' do
        result = setup_service.run(password_params, tfa_params)
        expect(result).to be true
      end

      it 'sets the users password' do
        expect(user.encrypted_password).to be_blank

        setup_service.run(password_params, tfa_params)
        expect(user.reload.encrypted_password).to_not be_blank
      end

      it 'enables the users otp' do
        expect(user.otp_required_for_login).to be false

        setup_service.run(password_params, tfa_params)
        user.reload

        expect(user.otp_required_for_login).to be true
        expect(user.otp_secret).to eq secret
      end
    end

    context 'token is invalid' do
      let!(:setup_service) { UserSetupService.new('abc', TwoFactorService) }

      it 'returns false' do
        result = setup_service.run({}, {})
        expect(result).to eq false
      end
    end

    context 'password has errors' do
      let!(:password_params) { {password: '', password_confirmation: '', reset_password_token: token} }
      let!(:tfa_params) { {otp_required_for_login: '1', otp_secret: secret, otp_attempt: otp_user.current_otp} }

      it 'returns false' do
        result = setup_service.run(password_params, tfa_params)
        expect(result).to eq false
      end

      it 'will not update the users password' do
        expect(user.encrypted_password).to be_blank

        result = setup_service.run(password_params, tfa_params)
        expect(result).to eq false

        expect(user.reload.encrypted_password).to be_blank
      end

      it 'doesn not enable the users otp' do
        expect(user.otp_required_for_login).to be false

        setup_service.run(password_params, tfa_params)
        user.reload

        expect(user.otp_required_for_login).to be false
        expect(user.otp_secret).to be nil
      end
    end
  end
end
