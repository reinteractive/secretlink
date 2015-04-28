# If you want to limit the amount of time a secret can be stored, set the time
# limit here. e.g. if you set 7.days, any secrets older than 7 days cannot be
# accessed and will be deleted.
# Set to nil or comment the line if you don't want to enforce this restriction
Rails.configuration.snapsecret_maximum_expiry_time = 7.days.to_i

# Only allow secrets to be created by email addresses from certain domains.
# e.g. if you set to 'acme.com', only email addresses @acme.com will be able to
# create secrets, anyone else who requests an auth token will receive an error.
# Takes a single string: 'acme.com' or an array: ['acme.com', 'acme.org']
# Set to nil or comment the line if you don't want to enforce this restriction
Rails.configuration.snapsecret_domains_allowed_to_create_secrets = ENV['SNAPSECRET_ALLOWED_CREATE']

# Only allow secrets to be shared with email addresses from certain domains.
# e.g. if you set to 'acme.com', only email addresses @acme.com will be able to
# receive secrets, setting the 'To address' setting to another domain will
# receive an error when creating a secret.
# Takes a single string: 'acme.com' or an array: ['acme.com', 'acme.org']
# Set to nil or comment the line if you don't want to enforce this restriction
Rails.configuration.snapsecret_domains_allowed_to_receive_secrets = ENV['SNAPSECRET_ALLOWED_RECEIVE']
