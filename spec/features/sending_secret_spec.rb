require "rails_helper"

describe "Sending a secret" do

  let(:user) { create :user }
  let(:to_email)   { "to@example.com" }

  describe "creating a secret" do
    let(:secret) { Secret.last }

    before do
      login_as(user)
      visit new_secret_path
      fill_in "Title", with: "Super Secret"
      fill_in "Recipient", with: to_email
      fill_in "Secret", with: "AbC123"
      fill_in "Comments", with: "Some super secret info"
      fill_in "Expire at", with: (Time.current + 1.day).strftime("%d %B, %Y")
      click_button "Send your Secret"
      expect(current_path).to eql(dashboard_path)
    end

    it "allows a secret to be created" do
      expect(secret.title).to eq("Super Secret")
      expect(secret.from_email).to eq(user.email)
      expect(secret.to_email).to eq(to_email)
      expect(secret.comments).to eq("Some super secret info")
      expect(secret.expire_at).to eq((Date.current + 1).strftime("%Y-%m-%d"))
      expect(secret.secret_file).to_not be_nil
    end

    it "sends an email to the recipient" do
      email = ActionMailer::Base.deliveries.last
      expect(email.to).to eq([to_email])
      expect(email.reply_to).to eq([user.email])
      expect(email.subject).to eq("SecretLink.org: A secret has been shared with you - Reference #{Secret.last.uuid}")
      expect(email.from).to eq(["info@SecretLink.org"])
      expect(email.to_s).to match("This link will show you the secret:")
      expect(email.to_s).to match(/\/secrets\/#{secret.uuid}\?key=\w+/)
    end

    it "encrypts the secret in the db" do
      expect(secret.encrypted_secret).to_not be_nil
      expect(secret.encrypted_secret).to_not eq("AbC123")
      expect(secret.encrypted_secret_salt).to_not be_nil
      expect(secret.encrypted_secret_iv).to_not be_nil
      expect(secret.secret_key).to be_nil
    end

    it "allows oauth to authenticate when creating a secret"

  end

  describe "accessing a secret" do

    let!(:secret) {
      SecretService.encrypt_new_secret({from_email: user.email,
                                        to_email: to_email,
                                        secret: "Super Secret Message",
                                        expire_at: Time.current + 7.days})
    }
    let!(:link_to_secret) { ActionMailer::Base.deliveries.last.text_part.to_s.match(/http[\S]+/) }

    before do
      visit link_to_secret
    end

    it "provides a link to show the secret but does not delete it yet" do
      expect(page.html).to match("Click here to show the secret")
      expect(Secret.find(secret.id).encrypted_secret).to_not be_nil
    end

    it "can handle a virus checker visiting the first page" do
      expect(page.html).to match("Click here to show the secret")
      expect(Secret.find(secret.id).encrypted_secret).to_not be_nil
      expire_cookies
      visit link_to_secret
      expect(page.html).to match("Click here to show the secret")
      expect(Secret.find(secret.id).encrypted_secret).to_not be_nil
    end

    it "retrieves and decrypts the secret" do
      click_button "Click here to show the secret"
      expect(page).to have_content("Super Secret Message")
    end

    it "works with attachments"

    it "deletes the secret after it has been accessed" do
      click_button "Click here to show the secret"
      expect(page).to have_content("Super Secret Message")
      secret.reload
      expect(secret.encrypted_secret).to be_nil
      expect(secret.consumed_at).to_not be_nil
    end

    it "deletes an attachment after it has been accessed"

    it "notifies the creator of the secret that it has been accessed and deleted" do
      click_button "Click here to show the secret"
      expect(page).to have_content("Super Secret Message")
      email = ActionMailer::Base.deliveries.last
      expect(email.to).to eq([user.email])
      expect(email.reply_to).to eq([to_email])
      expect(email.subject).to eq("Your secret was consumed on SecretLink.org - Reference #{Secret.last.uuid}")
      expect(email.from).to eq(["info@SecretLink.org"])
      expect(email.text_part.to_s).to match(user.email)
      expect(email.text_part.to_s).to match("The encrypted information has now been deleted from the database")
    end

  end

  describe "trying to access an expired secret" do

    let!(:secret) {
      SecretService.encrypt_new_secret({from_email: user.email,
                                        to_email: to_email,
                                        secret: "Super Secret Message",
                                        expire_at: Time.now - 1})
    }
    let!(:link_to_secret) { ActionMailer::Base.deliveries.last.text_part.to_s.match(/http[\S]+/)}

    # Even if the expired secret worker isn't working the secret shouldn't be accessible
    it "informs the secret is expired and ensures the encrypted secret is removed" do
      visit link_to_secret
      expect(page).to have_content I18n.t('secrets.expired_error')
      expect(page).to_not have_content("Super Secret Message")
    end

  end
end
