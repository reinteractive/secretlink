class AuthTokenService

  def self.generate(auth_hash)
    auth_token = AuthToken.create(auth_hash)
    auth_token.notify if auth_token.persisted?
    auth_token
  end

end
