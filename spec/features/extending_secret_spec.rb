require 'rails_helper'

describe 'Extending secret' do
  let!(:user) { create :user }
  let!(:secret) { create :secret, title: 'Valid Secret', user: user }
  let!(:consumed_secret) { create :secret, :consumed, title: 'Consumed Secret', user: user }
  let!(:expired_secret) { create :secret, :expired, title: 'Expired Secret', user: user }

  before do
    login_as(user)
    Timecop.freeze
  end

  after { Timecop.return }

  before do
    visit dashboard_path
  end

  it 'shows the correct label for consumed secrets' do
    within(:css, '.secret-item.viewed') do
      expect(page).to have_content("Consumed Secret")
      expect(page).to have_content("Viewed and Deleted")
    end
  end

  it 'does not allow to extend unexpired secrets' do
    within(:css, '.secret-item.not-viewed:not(.expired)') do
      expect(page).to have_content("Valid Secret")
      expect(page).to_not have_content 'Extend'
    end
  end

  it 'allows to extend expiry of unconsumed and expired secret' do
    within(:css, '.secret-item.not-viewed.expired') do
      expect(page).to have_content("Expired Secret")
      click_on "Extend"
    end

    expect(page).to have_content(I18n.t('secrets.extended_expiry', title: expired_secret.title))
    expect(expired_secret.reload.expire_at).to eq Time.current + 1.week
  end
end
