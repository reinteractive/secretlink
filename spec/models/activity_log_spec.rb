require 'rails_helper'

describe ActivityLog do
  describe 'validations' do
    let!(:trackable) { create :secret }

    it 'validates presence of key, owner, trackable' do
      log = ActivityLog.new

      expect(log).to_not be_valid
      expect(log.errors.messages[:key]).to include "can't be blank"
      expect(log.errors.messages[:owner]).to include "can't be blank"
      expect(log.errors.messages[:trackable]).to include "can't be blank"
    end

    it 'validates for the key based on trackable' do
      log = ActivityLog.new(key: 'wrong key', trackable: trackable)

      expect(log).to_not be_valid
      expect(log.errors.messages[:key]).to include "is invalid"
    end
  end
end
