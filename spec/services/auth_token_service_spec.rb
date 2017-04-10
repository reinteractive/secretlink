require "rails_helper"

describe AuthTokenService do
  let(:sender) { "sender@email.com" }
  let(:hash) {  { email: sender }}
  let!(:auth_token) { AuthToken.new(hash) }

  describe "#generate" do
    let(:params) { { email: "superman@gmail.com" } }
    let(:request_host) { "http://localhost:3000" }

    it "creates a token" do
      expect {
          AuthTokenService.generate(params)
        }.to change(AuthToken, :count).by(1)
    end

    context "valid auth_token" do

      it "tells the auth_token to notify if persisted" do
        expect_any_instance_of(AuthToken).to receive(:notify).once
        AuthTokenService.generate(params)
      end

    end

    context "invalid auth_token" do

      it "does not tell the auth_token to notify" do
        expect_any_instance_of(AuthToken).to_not receive(:notify)
        AuthTokenService.generate(params.merge!(email: ''))
      end

    end

  end

end
