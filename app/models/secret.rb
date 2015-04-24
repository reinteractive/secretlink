class Secret < ActiveRecord::Base
  attr_accessor :secret_key
  attr_encrypted :secret, key: :secret_key, mode: :per_attribute_iv_and_salt
  mount_uploader :secret_file, SecretFileUploader
  validates_presence_of :to_email, message: "Please enter the recipient's email address"
  validates_presence_of :secret, message: "Please enter a secret to share with the recipient"
  validate :expire_at_within_limit
  validate :to_email_domain_authorised

  scope :created_by_email, ->(email) { where(from_email: email) }

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

  def to_email_domain_authorised
    authorised_domains = Rails.application.config.snapsecret_domains_allowed_to_receive_secrets
    email_domain = to_email.to_s.split('@')[1]
    if authorised_domains && email_domain && [authorised_domains].flatten.exclude?(email_domain)
      errors.add(:to_email, "Secrets can only be shared with emails " +
        [authorised_domains].flatten.map { |e| '@'+e }.join(', ') )
    end
    true
  end

  def status
    if encrypted_secret.blank?
      'viewed'
    elsif expire_at && expire_at < Time.now
      'expired'
    elsif (!expire_at || expire_at > Time.now) && encrypted_secret.present?
      'pending'
    else
      'unknown'
    end
  end

  def self.expire_at_hint
    if Rails.application.config.snapsecret_maximum_expiry_time
      (Date.today + 1).strftime('%d %B %Y') + ' - ' +
      (Time.now + Rails.application.config.snapsecret_maximum_expiry_time).strftime('%d %B %Y')
    end
  end
end