class Secret < ActiveRecord::Base
  attr_accessor :secret_key
  attr_encrypted :secret, key: :secret_key, mode: :per_attribute_iv_and_salt
  mount_uploader :secret_file, SecretFileUploader
  validates_presence_of :to_email, message: "Please enter the recipient's email address"
  validates_presence_of :secret, message: "Please enter a secret to share with the recipient"
  validate :expire_at_within_limit
  validate :email_domain_authorised

  scope :with_email_and_access_key, ->(email, access_key){
    where('from_email = ? and access_key = ?', email, access_key)
  }

  def delete_encrypted_information
    update_attribute(:secret, nil)
  end

  def self.exist?(from_email, access_key)
    with_email_and_access_key(from_email, access_key).any?
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
    authd_domain = Rails.configuration.topsekrit_authorised_domain
    case Rails.configuration.topsekrit_authorisation_setting
    when :open
      return
    when :closed
      if email_does_not_match?(to_email)
        errors.add(:to_email, "Secrets can only be shared with emails @" + authd_domain)
      end
      if email_does_not_match?(from_email)
        errors.add(:from_email, "Secrets can only be shared by emails @" + authd_domain)
      end
    when :limited
      if email_does_not_match?(to_email) && email_does_not_match?(from_email)
        errors.add(:to_email, "Secrets can only be shared by or with emails @" + authd_domain)
      end
    end
  end

  def email_does_not_match?(email)
    AuthorisedEmailService.email_domain_does_not_match?(email)
  end

  def self.expire_at_hint
    if Rails.application.config.topsekrit_maximum_expiry_time
      (Date.today + 1).strftime('%d %B %Y') + ' - ' +
      (Time.now + Rails.application.config.topsekrit_maximum_expiry_time).strftime('%d %B %Y')
    end
  end
end
