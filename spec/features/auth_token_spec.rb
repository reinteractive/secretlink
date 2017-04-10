require "rails_helper"

describe AuthToken do

  let(:from_email) { "from@example.com" }

  it "allows sending a token without javascript support" do
    visit root_path
    expect(page).to have_content("Share a secret now...")
    fill_in "auth_token[email]", with: from_email
    expect {
      click_button "Send TopSekr.it Token"
    }.to change(AuthToken, :count).by(1)
  end

  it "generates an auth token", js: true do
    visit root_path
    expect(page).to have_content("Share a secret now...")
    fill_in "auth_token[email]", with: from_email
    page.driver.scroll_to(0, 500)
    expect {
      click_button "Send TopSekr.it Token"
    }.to change(AuthToken, :count).by(1)
  end

  it "provides a message if a token is invalid" do
    visit "/auth_tokens/ijustmadethisup"
    expect(page).to have_content("Sorry, we don't know who you are, try sending a new token!")
  end

  describe "with an existing auth token saved to the database" do

    let!(:auth_token) {
      AuthToken.create(
        email: from_email
      )
    }

    it "finds the token and deletes it" do
      expect {
        visit auth_token_path(auth_token.hashed_token)
        }.to change(AuthToken.where(hashed_token: auth_token.hashed_token), :count).by(-1)
    end

    it "redirects to the new secret page with the sender's address filled in" do
      visit auth_token_path(auth_token.hashed_token)
      expect(current_path).to eq(new_secret_path)
      expect(find("#secret_from_email").value).to eq(from_email)
    end

  end

  describe "trying to create an auth token from a non approved domain" do

    let!(:auth_token) {
      AuthToken.create(
        email: from_email
      )
    }

    it "finds the token and deletes it" do
      expect {
        visit auth_token_path(auth_token.hashed_token)
        }.to change(AuthToken.where(hashed_token: auth_token.hashed_token), :count).by(-1)
    end

    it "redirects to the new secret page with the sender's address filled in" do
      visit auth_token_path(auth_token.hashed_token)
      expect(current_path).to eq(new_secret_path)
      expect(find("#secret_from_email").value).to eq(from_email)
    end

  end

end
