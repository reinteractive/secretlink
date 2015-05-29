# If you want to limit the amount of time a secret can be stored, set the time
# limit here. e.g. if you set 7.days, any secrets older than 7 days cannot be
# accessed and will be deleted.
# Set to nil or comment the line if you don't want to enforce this restriction
Rails.configuration.snapsecret_maximum_expiry_time = 7.days.to_i

# These settings define who can use the website to send and receive secrets.
# The options for snapsecret_authorisation_setting are:
# [:open, :closed, :limited]
# :open - anyone can use the website to send or receive secrets, ignores the
#         snapsecret_authorised_domain setting, yolo.
# :closed - only emails from the snapsecret_authorised_domain domain can send and receive secrets,
#           use this if you only want to use snapsecret internally
# :limited - emails from the snapsecret_authorised_domain domain can send secrets to anyone and can
#            receive secrets from anyone, but emails from other domains can't send/receive secrets
#            to/from each other
Rails.configuration.snapsecret_authorisation_setting = ENV['SNAPSECRET_AUTHORISATION_SETTING']
Rails.configuration.snapsecret_authorised_domain = ENV['SNAPSECRET_AUTHORISED_DOMAIN']