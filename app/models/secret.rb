class Secret < ApplicationRecord
  attr_accessor :secret_key

  #attr_encrypted :secret, key: :secret_key, mode: :per_attribute_iv_and_salt
  attr_encrypted_encrypted_attributes :secret, key: :secret_key, mode: :per_attribute_iv_and_salt
  mount_uploader :secret_file, SecretFileUploader

  validates :from_email, presence: {
                           message: "Please enter the senders's email address"
                         }

  validates :to_email, presence: {
                         message: "Please enter the senders's email address"
                       }

  validates :secret, presence: {
                        message: "Please enter a secret to share with the recipient",
                     }

  validate :expire_at_within_limit
  validate :email_domain_authorised

  scope :with_email_and_access_key, ->(email, access_key){
    where('from_email = ? and access_key = ?', email, access_key)
  }

  def delete_encrypted_information
    update_attribute(:secret, nil)
  end

  def mark_as_consumed
    update_attribute(:consumed_at, Time.now)
  end

  def expired?
    expire_at.present? && expire_at < Time.now
  end

  def expire_at_within_limit
    if Rails.application.config.topsekrit_maximum_expiry_time
      max_expiry_in_config = (Time.now + Rails.application.config.topsekrit_maximum_expiry_time).to_i
      if expire_at.blank? || (expire_at && expire_at.to_i > max_expiry_in_config)
        errors.add(:expire_at, "Maximum expiry allowed is " +
        (Time.now + Rails.application.config.topsekrit_maximum_expiry_time).strftime('%d %B %Y'))
      end
    end
  end

  def email_domain_authorised
    if closed? && email_domain_does_not_match?
      errors.add(:base, "This system has been locked to only allow secrets to be sent to #{authorised_domain} email addresses.")
    end
  end

  def authorised_domain
    Rails.configuration.topsekrit_authorised_domain
  end

  def closed?
    [:closed].include?(Rails.configuration.topsekrit_authorisation_setting)
  end

  def email_domain_does_not_match?
    AuthorisedEmailService.email_domain_does_not_match?(to_email)
  end

  def self.expire_at_hint
    if Rails.application.config.topsekrit_maximum_expiry_time
      (Date.today + 1).strftime('%d %B %Y') + ' - ' +
      (Time.now + Rails.application.config.topsekrit_maximum_expiry_time).strftime('%d %B %Y')
    end
  end
end
