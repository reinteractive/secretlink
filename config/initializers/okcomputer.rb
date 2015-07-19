##
## OkComputer provides customizable health check endpoints
## (https://github.com/sportngin/okcomputer).
## It is an important piece of the OpsCare stack.
## Don't edit this file unless you know what you are doing,
## it could result in an undeployable app.
##
require 'securerandom'

# If the envvar is not set, generate a random string.
# It will be inaccessible, but at least secured.
healthcheck_token = ENV['HEALTHCHECK_TOKEN'].blank? ? SecureRandom.hex(32) : ENV['HEALTHCHECK_TOKEN']

# Mount the health checks at a tokenized url
OkComputer.mount_at = "health_checks_#{healthcheck_token}"

# The common checks we would want
# See here for othe built in checks:
# https://github.com/sportngin/okcomputer/tree/master/lib/ok_computer/built_in_checks
OkComputer::Registry.register "db",           OkComputer::ActiveRecordCheck.new
OkComputer::Registry.register "revision",     OkComputer::AppVersionCheck.new
OkComputer::Registry.register "ruby_version", OkComputer::RubyVersionCheck.new

## To add custom checks, uncomment and adapt the lines bellow:
## beware that a false return value will cause the deploys to fail.
## (example from documentation)

# class MyCustomCheck < OkComputer::Check
#   def check
#     if rand(10).even?
#       mark_message "Even is great!"
#     else
#       mark_failure
#       mark_message "We don't like odd numbers"
#     end
#   end
# end

# OkComputer::Registry.register "check_for_odds", MyCustomCheck.new
