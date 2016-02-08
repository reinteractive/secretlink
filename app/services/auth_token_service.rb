class AuthTokenService

  def self.generate(auth_hash, request_host)
    access_key = nil
    recipient_email = auth_hash['recipient_email']

    auth_token = AuthToken.new(auth_hash).generate

    if recipient_email
      # generate a seperate authentication for the recipient
      AuthToken.new(email:  recipient_email).generate

      # cretae an empty secret
      access_key = SecureRandom.hex(10)
      SecretService.create_empty_secret(auth_hash['email'],
                                        auth_hash['recipient_email'],
                                        access_key)
    end
    auth_token.notify(request_host, access_key)
  end

end
