require "rails_helper"

describe "Registering on a limited system" do

  let(:user) { create :user, email: "from@example.com" }
  let(:disapproved_email) { "from@example.org" }
  let(:authorised_domain) { "example.com" }

  before(:each) do
    allow(Rails.configuration).to \
      receive(:topsekrit_authorisation_setting).and_return(:limited)

    allow(Rails.configuration).to \
      receive(:topsekrit_authorised_domain).and_return(authorised_domain)
  end

  context "using an approved email domain" do
    it "allows the user to register"
  end

  context "trying to use a disapproved email domain" do
    it "doesn't allow the user to register"
  end
end
