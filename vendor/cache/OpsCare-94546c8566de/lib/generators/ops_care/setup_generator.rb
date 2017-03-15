require 'rails/generators'

module OpsCare
  class SetupGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)

    def copy_okcomputer_initializer_file
      copy_file "okcomputer.rb", "config/initializers/okcomputer.rb"
    end
    def copy_bugsnag_initializer_file
      copy_file "bugsnag.rb", "config/initializers/bugsnag.rb"
    end
    def setup_skylight
      copy_file "skylight.yml", "config/skylight.yml"

      inject_into_file 'config/application.rb', after: "class Application < Rails::Application\n" do <<-'RUBY'

    config.skylight.environments += ['staging']
    config.skylight.alert_log_file = true

      RUBY
      end
    end
    def copy_deploy_hooks
      directory 'deploy_hooks', 'config/deploy/hooks'
    end
    def copy_rake_tasks
      directory 'rake_tasks', 'lib/tasks'
    end
  end
end
