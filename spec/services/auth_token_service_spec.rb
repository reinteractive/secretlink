require 'rails_helper'

describe AuthTokenService do
  let(:sender) { 'sender@email.com' }
  let(:recipient_email) { nil }
  let(:hash) {  {'email' => sender,
                 'recipient_email' => recipient_email}}
  let!(:auth_token) { AuthToken.new(hash) }

  describe "#generate" do
    let(:recipient_email) { nil }
    let(:params) { {"email"=>"superman@gmail.com", "recipient_email"=> recipient_email} }
    let(:request_host) { 'http://localhost:3000' }

    it 'should call auth_token class methods' do
      expect(auth_token).to receive(:generate)
      auth_token.generate()
    end

    context "when it has a recipient_email" do
      let!(:recipient_email) { 'batman@gmail.com' }

      it 'should create two authentication tokens' do
        expect {
                 AuthTokenService.generate(params, request_host)
               }.to change(AuthToken, :count).by(2)
      end

      it 'should create an empty secret' do
        expect(SecretService).to receive(:create_empty_secret).once
        AuthTokenService.generate(params, request_host)
      end
    end

    context "when a recipient_email is not given" do
      let!(:recipient_email) { nil }
      it 'should create only one token' do
        expect {
                 AuthTokenService.generate(params, request_host)
               }.to change(AuthToken, :count).by(1)
      end
      it 'should not create a secret' do
        expect {
                 AuthTokenService.generate(params, request_host)
               }.to change(Secret, :count).by(0)
      end
    end


    context "when with both sender and recipient emails" do
      let!(:recipient_email) { 'recipient_email@email.com' }

      it 'should create a blank secret' do
        expect{subject.class.generate(hash, 'host')}.to change(Secret, :count).by(1)
      end

    end
  end

end
