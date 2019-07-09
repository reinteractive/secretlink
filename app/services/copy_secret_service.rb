class CopySecretService
  attr_reader :session

  KEY = :copy_secret_key
  UUID = :copy_secret_uuid

  def initialize(session)
    @session = session
  end

  def prepare!(secret)
    session[KEY] = secret.secret_key
    session[UUID] = secret.uuid
  end

  def copy!
    if session[KEY] && session[UUID]
      data = {key: session[KEY], uuid: session[UUID]}

      session.delete(KEY)
      session.delete(UUID)
      data
    else
      false
    end
  end
end
