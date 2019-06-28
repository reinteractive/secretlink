require 'rails_helper'

describe 'Resending secret' do
  let!(:user) { create :user }
  let!(:secret) { create :secret, user: user }
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
      expect(page).to have_content("Viewed and Deleted")
    end
  end

  it 'shows the correct label for expired secrets' do
    within(:css, '.secret-item.not-viewed.expired') do
      expect(page).to have_content("Expired")
    end
  end

  it 'allows to resend unconsumed and unexpired secrets' do
    within(:css, '.secret-item.not-viewed:not(.expired)') do
      click_on "Resend Link"
    end

    expect(page).to have_content(I18n.t('secret.resend.success', email: secret.to_email))
    email = ActionMailer::Base.deliveries.last
    expect(email.to).to eq([secret.to_email])
    expect(email.reply_to).to eq([user.email])
    expect(email.subject).to eq("SecretLink.org: A secret has been shared with you - Reference #{secret.uuid}")
    expect(email.from).to eq(["info@SecretLink.org"])
    expect(email.to_s).to match("This link will show you the secret:")
    expect(email.to_s).to match(/\/secrets\/#{secret.uuid}\?key=\w+/)
  end
end
