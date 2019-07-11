class ActivityLogger
  attr_reader :actor

  def initialize(actor)
    @actor = actor
  end

  def perform(key, trackable, recipient = nil)
    # Right now this is just a method call wrapped in a class
    # But still we're doing it to hide the implementation details
    # We may consider to change logging in the future
    # And this is the only place we will go to

    # And also, it pays to make sure that we're always calling the bang(!)
    # This step should not fail in production
    ActivityLog.create!(
      key: key,
      owner: actor,
      trackable: trackable,
      recipient: recipient)
  end
end
