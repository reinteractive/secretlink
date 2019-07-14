require 'rails_helper'

describe 'Viewing settings spec', js: true do
  let!(:user) { create :user }

  before do
    login_as(user)
    visit dashboard_path
  end

  it 'shows the account settings page' do
    click_on 'Account'
    click_on 'Settings'

    expect(page).to have_content('Account Settings')
    expect(page).to have_link(nil, href: edit_two_factor_auth_path)
  end
end
