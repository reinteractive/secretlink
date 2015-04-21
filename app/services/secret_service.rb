class SecretService

  # The Secret#secret_key value isn't persisted - it is used to encrypt the secret
  # and the only copy of it is sent in the notification email to the recipient.
  def self.encrypt_secret(params, request_host)
    secret = Secret.create(params.merge(uuid: SecureRandom.uuid, secret_key: SecureRandom.hex))
    SecretMailer.secret_notification(secret, request_host).deliver_now if secret.persisted?
    secret
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