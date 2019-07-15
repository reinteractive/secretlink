class SecretService

  # TODO: Instantiate the service instead and assign the logger
  # as instance property
  def self.encrypt_new_secret(params, logger = nil)
    secret = Secret.create(params.merge(uuid: SecureRandom.uuid, secret_key: SecureRandom.hex(16)))
    if secret.persisted? && !secret.no_email?

      logger.perform(Secret::ACTIVITY_LOG_KEYS[:created], secret) if logger

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

  def self.decrypt_secret!(secret, password, logger = nil)
    secret.secret_key = password
    s = secret.secret
    secret.mark_as_consumed
    secret.delete_encrypted_information

    if logger
      # In this case, this happens at almost the same time
      # Later we will have a script that deletes expired
      # but unconsumed secrets
      logger.perform(Secret::ACTIVITY_LOG_KEYS[:consumed], secret)
      logger.perform(Secret::ACTIVITY_LOG_KEYS[:deleted], secret)
    end


    # TODO: Mailers should be in the background
    SecretMailer.consumnation_notification(secret).deliver_now
    s
  end

end
