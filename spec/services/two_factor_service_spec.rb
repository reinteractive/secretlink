require 'rails_helper'

describe TwoFactorService do
  let(:user) { create :user }
  let(:tfa) { TwoFactorService.new(user) }

  describe '#issue_otp_secret' do
    it 'sets the users otp_secret' do
      expect(tfa.user.otp_secret).to be_nil

      tfa.issue_otp_secret
      expect(tfa.user.otp_secret).to_not be_nil
    end
  end

  describe '#generate_otp_provisioning_uri' do
    it 'returns a qrcode source' do
      source = 'otpauth://totp/Secret%20Link:user@secretlink.org?issuer=Secret+Link'
      expect(tfa.generate_otp_provisioning_uri).to eq source
    end
  end

  describe '#enable_otp' do
    let!(:otp_secret) { tfa.issue_otp_secret }

    context 'successful' do
      it 'returns true' do
        result = tfa.enable_otp(otp_secret, tfa.user.current_otp, 'password')
        expect(result).to be true
      end

      it 'sets otp_secret and otp_required_for_login' do
        tfa.enable_otp(otp_secret, tfa.user.current_otp, 'password')

        user.reload
        expect(user.otp_secret).to eq otp_secret
        expect(user.otp_required_for_login).to be true
        expect(user.changed?).to be false
      end
    end

    context 'wrong password' do
      let!(:result) { tfa.enable_otp(otp_secret, tfa.user.current_otp, 'wrong password') }

      it 'returns false' do
        expect(result).to be false
      end

      it 'adds current password error' do
        expect(tfa.user.errors.added?(:current_password, :invalid)).to be true
      end

      it 'does not update the user' do
        user.reload
        expect(user.otp_secret).to be nil
        expect(user.otp_required_for_login).to be false
        expect(tfa.user.changed?).to be true
      end
    end

    context 'wrong otp secret' do
      let!(:result) { tfa.enable_otp(otp_secret, 'wrong otp_secret', 'password') }

      it 'returns false' do
        expect(result).to be false
      end

      it 'adds otp_attempt error' do
        expect(tfa.user.errors.added?(:otp_attempt, :invalid)).to be true
      end

      it 'does not update the user' do
        user.reload
        expect(user.otp_secret).to be nil
        expect(user.otp_required_for_login).to be false
        expect(tfa.user.changed?).to be true
      end
    end
  end

  describe '#enable_otp_without_password' do
    let!(:otp_secret) { tfa.issue_otp_secret }

    context 'successful' do
      it 'returns true' do
        result = tfa.enable_otp_without_password(otp_secret, tfa.user.current_otp)
        expect(result).to be true
      end

      it 'sets otp_secret and otp_required_for_login' do
        tfa.enable_otp_without_password(otp_secret, tfa.user.current_otp)

        user.reload
        expect(user.otp_secret).to eq otp_secret
        expect(user.otp_required_for_login).to be true
        expect(user.changed?).to be false
      end
    end
  end

  describe '#disable_otp' do
    let!(:otp_secret) { tfa.issue_otp_secret }

    context 'successful' do
      before do
        tfa.enable_otp(otp_secret, tfa.user.current_otp, 'password')
      end

      it 'returns true' do
        expect(tfa.disable_otp("password")).to eq true
      end

      it 'sets otp_required_for_login to false' do
        tfa.disable_otp("password")
        expect(user.reload.otp_required_for_login).to eq false
      end
    end

    context 'failed' do
      before do
        tfa.enable_otp(otp_secret, tfa.user.current_otp, 'password')
      end

      it 'returns false' do
        expect(tfa.disable_otp("wrong password")).to eq false
      end

      it 'it does not set otp_required_for_login' do
        tfa.disable_otp("wrong password")
        expect(user.reload.otp_required_for_login).to eq true
      end
    end
  end
end
