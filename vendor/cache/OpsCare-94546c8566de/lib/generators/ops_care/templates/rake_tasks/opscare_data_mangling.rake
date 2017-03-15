# This task purpose is to alter data so it is safe
# to be used in an environment other than production..

# Usually, it will consist of altering the email addresses, payment details
# or other sensitive data.

# Actual actions depend on the application's business logic.

# This task is called automatically by OpsCare's `db_replicate` command.

namespace :opscare do
  namespace :data do

    def get_db_config(env)
      db_config = Rails.application.config.database_configuration[env]
      db_config
    end

    desc "Mangle data for a safer usage in envs other than prod"
    task mangle: :environment do |t,args|
      # Fail safe. Don't remove this test!
      if ENV['RAILS_ENV'] == 'production'
        puts "You probably don't want to mangle production data..."
        puts "Exiting"
        exit
      end

      # Get the DB config if you're calling it directly
      db = get_db_config(ENV['RAILS_ENV'])

      # Example action: adding ".local" at the end of the user.email field
      # (beware it will also edit your admin user account):

      # puts "Mangling emails addresses by appending '.local'"
      # %w( users ).each do |table|
      #   %x[ export PGPASSWORD=#{db['password']}; psql -h #{db['host']} -U #{db['username']} #{db['database']} -c "update #{table} set email= email || '.local' where email not like '%.local';" ]
      # end

    end # task :mangle

  end # namespace :data
end # namespace :opscare
