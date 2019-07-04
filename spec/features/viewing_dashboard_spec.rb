require 'rails_helper'

describe 'Viewing Dashboard' do
  let!(:user) { create :user }
  let!(:dashboard_time_format) { I18n.t('date.formats.dashboard_time') }

  before do
    login_as(user)
    Timecop.freeze
  end

  after { Timecop.return }

  context 'user has not sent a secret yet' do
    it 'redirects to secrets_new_path' do
      visit dashboard_path
      expect(page).to have_current_path(new_secret_path)
      expect(page).to have_content('Create a new secret')
      expect(page).to have_content(I18n.t('welcome'))
    end
  end

  context 'user has already sent his first secret' do
    let!(:secret) { create :secret }
    let!(:consumed_secret) {
      create :secret, :consumed,
      to_email: 'activeuser@random.com',
      title: 'Consumed Secret',
      comments: 'This is a consumed secret'
    }

    before do
      visit dashboard_path
    end

    it 'displays the unconsumed secret' do
      within(:css, '.secret-item.not-viewed') do
        expect(page).to have_content('Sample Secret')
        expect(page).to have_content(user.email)
        expect(page).to have_content('user@random.com')
        expect(page).to have_content("Sent: #{secret.created_at.strftime(dashboard_time_format)}")
        expect(page).to have_content('not viewed')
        expect(page).to have_content("expiry: #{secret.expire_at.strftime(dashboard_time_format)}")

        find('.notes-trigger').click
        expect(page).to have_content('This is a sample secret')
      end
    end

    it 'displays the consumed secret' do
      within(:css, '.secret-item.viewed') do
        expect(page).to have_content('Consumed Secret')
        expect(page).to have_content(user.email)
        expect(page).to have_content('activeuser@random.com')
        expect(page).to have_content("Sent: #{consumed_secret.created_at.strftime(dashboard_time_format)}")
        expect(page).to have_content("Viewed: #{consumed_secret.consumed_at.strftime(dashboard_time_format)}")

        find('.notes-trigger').click
        expect(page).to have_content('This is a consumed secret')
      end
    end

    it 'has a link to create new secret' do
      click_on 'Create New'
      expect(page).to have_current_path(new_secret_path)
      expect(page).to have_content('Create a new secret')
    end
  end
end
