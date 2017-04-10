class SecretService

  def self.encrypt_new_secret(params)
    secret = Secret.create(params.merge(uuid: SecureRandom.uuid, secret_key: SecureRandom.hex(16)))
    if secret.persisted?
      # TODO: Mailers should be in the background
      SecretMailer.secret_notification(secret).deliver_now
    end
    secret
  end

  def self.correct_key?(secret, password)
    begin
      secret.secret_key = password
      secret.secret.present?
    rescue OpenSSL::Cipher::CipherError => e
      return false
    rescue ArgumentError => e
      return false
    end
  end

  def self.decrypt_secret!(secret, password)
    secret.secret_key = password
    s = secret.secret
    secret.delete_encrypted_information
    secret.mark_as_consumed
    # TODO: Mailers should be in the background
    SecretMailer.consumnation_notification(secret).deliver_now
    s
  end

end
