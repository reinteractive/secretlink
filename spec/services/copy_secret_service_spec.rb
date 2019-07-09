require 'rails_helper'

describe CopySecretService do
  let!(:secret) { create :secret }
  let!(:session) { Hash.new }
  let!(:service) { CopySecretService.new(session) }

  describe '#prepare!' do
    it 'sets the sessions key and uuid' do
      service.prepare!(secret)

      expect(session[:copy_secret_key]).to eq secret.secret_key
      expect(session[:copy_secret_uuid]).to eq secret.uuid
    end
  end

  describe '#copy!' do
    context 'key and uuid are set' do
      before do
        session[:copy_secret_key] = 'secret_key'
        session[:copy_secret_uuid] = 'secret_uuid'
      end

      it 'returns key and uuid data' do
        data = service.copy!

        expect(data[:key]).to eq 'secret_key'
        expect(data[:uuid]).to eq 'secret_uuid'
      end

      it 'deletes key and uuid from session' do
        service.copy!

        expect(session[:copy_secret_key]).to be nil
        expect(session[:copy_secret_uuid]).to be nil
      end
    end

    context 'key and uuid are not set' do
      before do
        session[:copy_secret_key] = nil
        session[:copy_secret_uuid] = nil
      end

      it 'returns false' do
        result = service.copy!
        expect(result).to be false
      end
    end
  end
end
