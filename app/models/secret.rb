class Secret < ActiveRecord::Base
  attr_accessor :secret_key
  attr_encrypted :secret, key: :secret_key, mode: :per_attribute_iv_and_salt
  mount_uploader :secret_file, SecretFileUploader
  validates_presence_of :to_email, message: "Please enter the recipient's email address"
  validates_presence_of :secret, message: "Please enter a secret to share with the recipient"

  def delete_encrypted_information
    update_attribute(:secret, nil)
  end

  def mark_as_consumed
    update_attribute(:consumed_at, Time.now)
  end

  def expired?
    expire_at < Time.now
  end
end