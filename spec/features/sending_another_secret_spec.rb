require 'rails_helper'

describe 'Sending another secret' do
  let!(:user) { create :user }
  let!(:secret) { create :secret, user: user }

  before do
    login_as(user)
    visit dashboard_path
    click_on 'Send Another'
  end

  it 'navigates to new secret page' do
    expect(page).to have_current_path(new_secret_path(base_id: secret.uuid))
  end

  it 'copies details of old secrets' do
    expect(page).to have_selector("input[value='#{secret.title}']")
    expect(page).to have_selector("input[value='#{secret.from_email}']")
    expect(page).to have_selector("input[value='#{secret.to_email}']")
    expect(page).to have_content(secret.comments)
  end
end
