require 'rails_helper'

describe 'Extending secret' do
  let!(:user) { create :user }
  let!(:secret) { create :secret, title: 'Valid Secret', user: user }
  let!(:extended_secret) { create :secret, :extended, title: 'Extended Secret', user: user }
  let!(:consumed_secret) { create :secret, :consumed, title: 'Consumed Secret', user: user }
  let!(:expired_secret) { create :secret, :expired, title: 'Expired Secret', user: user }
  let!(:expired_and_extended) { create :secret, :expired, :extended, title: 'Expired and Extended', user: user }

  before do
    login_as(user)
    visit dashboard_path
  end

  it 'shows the correct label for secrets' do
    within(:css, "##{secret.id}.secret-item") do
      expect(page).to have_content(secret.title)
      expect(page).to_not have_content('Extended')
      expect(page).to_not have_content('Viewed and Deleted')
      expect(page).to_not have_css('.extend-btn')
    end
  end

  it 'shows the correct label for consumed secrets' do
    within(:css, "##{consumed_secret.id}.secret-item") do
      expect(page).to have_content(consumed_secret.title)
      expect(page).to have_content('Viewed and Deleted')
      expect(page).to_not have_content('Extended')
      expect(page).to_not have_css('.extend-btn')
    end
  end

  it 'shows the extend button for expired secrets' do
    within(:css, "##{expired_secret.id}.secret-item") do
      expect(page).to have_content(expired_secret.title)
      expect(page).to have_css('.extend-btn')
      expect(page).to_not have_content('Viewed and Deleted')
      expect(page).to_not have_content('Extended')
    end
  end

  it 'shows the correct label for expired and extended secrets' do
    within(:css, "##{expired_and_extended.id}.secret-item") do
      expect(page).to have_content(expired_and_extended.title)
      expect(page).to have_content('Extended')
      expect(page).to_not have_content('Viewed and Deleted')
      expect(page).to_not have_css('.extend-btn')
    end
  end

  describe 'successful' do
    before do
      Timecop.freeze

      within(:css, "##{expired_secret.id}.secret-item") do
        expect(page).to have_content('Expired Secret')
        click_on 'Extend'
      end
    end

    after { Timecop.return }

    it 'allows to extend expiry of unconsumed and expired secret' do
      expect(page).to have_content(I18n.t('secrets.extended_expiry', title: expired_secret.title))
      expect(expired_secret.reload.expire_at).to eq Time.current + 1.week
    end

    it 'sets the extended_at column' do
      expect(expired_secret.reload.extended_at).to eq Time.current
    end
  end
end
