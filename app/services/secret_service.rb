class SecretService

  # The Secret#secret_key value isn't persisted - it is used to encrypt the secret
  # and the only copy of it is sent in the notification email to the recipient.
  def self.encrypt_existing_secret(id, params, request_host)
    secret = Secret.where(access_key: id, from_email: params[:from_email]).first
    if secret
      secret.update_attributes(params.merge(uuid: SecureRandom.uuid, secret_key: SecureRandom.hex))
      SecretMailer.secret_notification(secret, request_host).deliver_now if secret.persisted?
    end
    secret
  end

  def self.encrypt_new_secret(params, request_host)
    secret = Secret.create(params.merge(uuid: SecureRandom.uuid, secret_key: SecureRandom.hex))
    if secret
      secret.update_attributes(params.merge(uuid: SecureRandom.uuid, secret_key: SecureRandom.hex))
      SecretMailer.secret_notification(secret, request_host).deliver_now if secret.persisted?
    end
    secret
  end


  def self.create_empty_secret(from_email, to_email, access_key)
    secret = Secret.new(from_email: from_email, to_email: to_email, access_key: access_key)
    secret.save(validate: false)
  end

  def self.decrypt_secret(secret, password)
    secret.secret_key = password
    s = secret.secret
    secret.delete_encrypted_information
    secret.mark_as_consumed
    SecretMailer.consumnation_notification(secret).deliver_now
    s
  end

end
