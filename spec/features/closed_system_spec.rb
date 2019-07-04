require "rails_helper"

describe "Generating auth tokens on a closed system" do

  let(:user) { create :user, email: "user@example.com" }
  let(:authorised_domain) { "example.com" }

  before(:each) do
    allow(Rails.configuration).to \
      receive(:topsekrit_authorisation_setting).and_return(:closed)
    allow(Rails.configuration).to \
      receive(:topsekrit_authorised_domain).and_return(authorised_domain)

    login_as(user)
    visit new_secret_path

    fill_in "Title", with: "Super Secret"
    fill_in "Recipient", with: to_email
    fill_in "Secret", with: "My Secret Info"
    fill_in "Comments", with: "Here is the info you wanted"
    fill_in "Expire at", with: (Time.current + 1.day).strftime("%d %B, %Y")
  end

  context "sending to an approved email domain" do

    let(:to_email) { "to@example.com" }

    it "creates the secret without javascript" do
      expect {
        click_button "Send your Secret"
      }.to change(Secret, :count).by(1)
    end

  end

  context "sending to a disapproved email domain" do

    let(:to_email) { "to@disapproved.com" }

    it "does not create the secret without javascript" do
      expect {
        click_button "Send your Secret"
      }.to_not change(Secret, :count)
      expect(page).to have_content("This system has been locked to only allow secrets to be sent to #{authorised_domain} email addresses.")
    end

  end

end
