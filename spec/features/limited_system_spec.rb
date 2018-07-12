require "rails_helper"

describe "Generating auth tokens on a limited system" do

  let(:from_email) { "from@example.com" }
  let(:disapproved_email) { "from@example.org" }
  let(:authorised_domain) { "example.com" }

  before(:each) do
    allow(Rails.configuration).to \
      receive(:topsekrit_authorisation_setting).and_return(:limited)

    allow(Rails.configuration).to \
      receive(:topsekrit_authorised_domain).and_return(authorised_domain)

    allow_any_instance_of(AuthToken).to receive(:notify).and_return(true)

    visit new_auth_token_path
  end

  context "using an approved email domain" do

    it "generates an auth token without javascript" do
      visit root_path
      expect(page).to have_content("Share a secret now...")
      fill_in "auth_token[email]", with: from_email
      expect {
        click_button "Send SecretLink.org Token"
      }.to change(AuthToken, :count).by(1)
    end

    it "generates an auth token with javascript", js: true do
      visit root_path
      expect(page).to have_content("Share a secret now...")
      fill_in "auth_token[email]", with: from_email
      page.driver.scroll_to(0, 500)
      expect {
        click_button "Send SecretLink.org Token"
      }.to change(AuthToken, :count).by(1)
    end
  end

  context "trying to use a disapproved email domain" do

    it "returns an error without javascript" do
      visit root_path
      expect(page).to have_content("Share a secret now...")
      fill_in "auth_token[email]", with: disapproved_email
      expect {
        click_button "Send SecretLink.org Token"
      }.to_not change(AuthToken, :count)
      expect(page).to have_content("Only email addresses from #{authorised_domain} are authorised to create secrets")
    end

    it "returns an error with javascript", js: true do
      visit root_path
      expect(page).to have_content("Share a secret now...")
      fill_in "auth_token[email]", with: disapproved_email
      page.driver.scroll_to(0, 500)
      expect {
        click_button "Send SecretLink.org Token"
      }.to_not change(AuthToken, :count)
      expect(page).to have_content("Only email addresses from #{authorised_domain} are authorised to create secrets")
    end
  end

end
