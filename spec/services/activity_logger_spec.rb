require 'rails_helper'

describe ActivityLogger do
  let!(:user) { create :user }
  let!(:secret) { create :secret }
  let!(:logger) { ActivityLogger.new(user) }

  it 'logs the activity' do
    expect { logger.perform('created', secret) }
      .to change { ActivityLog.count }.by(1)
  end

  it 'logs the correct data' do
    logger.perform('created', secret)
    log = ActivityLog.last

    expect(log.key).to eq 'created'
    expect(log.owner).to eq user
    expect(log.trackable).to eq secret
  end
end
