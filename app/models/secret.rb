class Secret < ActiveRecord::Base
  attr_accessor :secret_key
  attr_encrypted :secret, key: :secret_key, mode: :per_attribute_iv_and_salt
  mount_uploader :secret_file, SecretFileUploader
  validates_presence_of :to_email, message: "Please enter the recipient's email address"
  validates_presence_of :secret, message: "Please enter a secret to share with the recipient"
  validate :expire_at_within_limit
  validate :email_domain_authorised

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
    if Rails.application.config.snapsecret_maximum_expiry_time
      max_expiry_in_config = (Time.now + Rails.application.config.snapsecret_maximum_expiry_time).to_i
      if expire_at.blank? || (expire_at && expire_at.to_i > max_expiry_in_config)
        errors.add(:expire_at, "Maximum expiry allowed is " +
        (Time.now + Rails.application.config.snapsecret_maximum_expiry_time).strftime('%d %B %Y'))
      end
    end
  end

  def email_domain_authorised
    authd_domain = Rails.configuration.snapsecret_authorised_domain
    case Rails.configuration.snapsecret_authorisation_setting
    when 'closed'
      if to_email_domain != authd_domain
        errors.add(:to_email, "Secrets can only be shared with emails @" + authd_domain)
      end
      if from_email_domain != authd_domain
        errors.add(:from_email, "Secrets can only be shared by emails @" + authd_domain)
      end
    when 'limited'
      if to_email_domain != authd_domain && from_email_domain != authd_domain
        errors.add(:to_email, "Secrets can only be shared by or with emails @" + authd_domain)
      end
    when 'closed'
      if to_email_domain != authd_domain || from_email_domain != authd_domain
        errors.add(:base, "Secrets can only be shared by or with emails @" + authd_domain)
      end
    end
  end

  def to_email_domain
    to_email.to_s.split('@')[1]
  end

  def from_email_domain
    from_email.to_s.split('@')[1]
  end

  def self.expire_at_hint
    if Rails.application.config.snapsecret_maximum_expiry_time
      (Date.today + 1).strftime('%d %B %Y') + ' - ' +
      (Time.now + Rails.application.config.snapsecret_maximum_expiry_time).strftime('%d %B %Y')
    end
  end
end