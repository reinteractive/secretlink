# -*- encoding: utf-8 -*-
# stub: opscare 1.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "opscare"
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Glenn Davy", "Joseph Glanville", "Mikel Lindsaar", "Raphael Campardou", "Tim Hemi"]
  s.bindir = "exe"
  s.date = "2015-07-10"
  s.email = ["support@reinteractive.net"]
  s.files = [".gitignore", "Gemfile", "README.md", "Rakefile", "bin/console", "bin/setup", "lib/generators/opscare/setup_generator.rb", "lib/generators/opscare/templates/bugsnag.rb", "lib/generators/opscare/templates/deploy_hooks/README.md", "lib/generators/opscare/templates/deploy_hooks/after_all.sh", "lib/generators/opscare/templates/deploy_hooks/after_assets.sh", "lib/generators/opscare/templates/deploy_hooks/after_bundle.sh", "lib/generators/opscare/templates/deploy_hooks/after_check.sh", "lib/generators/opscare/templates/deploy_hooks/after_cleanup.sh", "lib/generators/opscare/templates/deploy_hooks/after_deploy.sh", "lib/generators/opscare/templates/deploy_hooks/after_health_check.sh", "lib/generators/opscare/templates/deploy_hooks/after_migrate.sh", "lib/generators/opscare/templates/deploy_hooks/after_pull.sh", "lib/generators/opscare/templates/deploy_hooks/after_release.sh", "lib/generators/opscare/templates/deploy_hooks/after_rollback.sh", "lib/generators/opscare/templates/deploy_hooks/after_symlink.sh", "lib/generators/opscare/templates/deploy_hooks/before_assets.sh", "lib/generators/opscare/templates/deploy_hooks/before_bundle.sh", "lib/generators/opscare/templates/deploy_hooks/before_check.sh", "lib/generators/opscare/templates/deploy_hooks/before_cleanup.sh", "lib/generators/opscare/templates/deploy_hooks/before_deploy.sh", "lib/generators/opscare/templates/deploy_hooks/before_health_check.sh", "lib/generators/opscare/templates/deploy_hooks/before_migrate.sh", "lib/generators/opscare/templates/deploy_hooks/before_pull.sh", "lib/generators/opscare/templates/deploy_hooks/before_release.sh", "lib/generators/opscare/templates/deploy_hooks/before_rollback.sh", "lib/generators/opscare/templates/deploy_hooks/before_symlink.sh", "lib/generators/opscare/templates/deploy_hooks/services/delayed-job-service.sh", "lib/generators/opscare/templates/deploy_hooks/services/load.sh", "lib/generators/opscare/templates/deploy_hooks/services/puma-service.sh", "lib/generators/opscare/templates/deploy_hooks/services/pushr-service.sh", "lib/generators/opscare/templates/deploy_hooks/services/resque-service.sh", "lib/generators/opscare/templates/deploy_hooks/services/sidekiq-service.sh", "lib/generators/opscare/templates/deploy_hooks/services/unicorn-service.sh", "lib/generators/opscare/templates/okcomputer.rb", "lib/generators/opscare/templates/skylight.yml", "lib/opscare.rb", "lib/opscare/version.rb", "opscare.gemspec"]
  s.homepage = "https://github.com/reinteractive/opscare"
  s.rubygems_version = "2.4.6"
  s.summary = "Configuration and support for reinteractive's OpsCare service."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<skylight>, ["~> 0.6.1"])
      s.add_runtime_dependency(%q<okcomputer>, ["~> 1.4.0"])
      s.add_runtime_dependency(%q<bugsnag>, ["~> 2.0.3"])
      s.add_development_dependency(%q<bundler>, ["~> 1.10"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
    else
      s.add_dependency(%q<skylight>, ["~> 0.6.1"])
      s.add_dependency(%q<okcomputer>, ["~> 1.4.0"])
      s.add_dependency(%q<bugsnag>, ["~> 2.0.3"])
      s.add_dependency(%q<bundler>, ["~> 1.10"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
    end
  else
    s.add_dependency(%q<skylight>, ["~> 0.6.1"])
    s.add_dependency(%q<okcomputer>, ["~> 1.4.0"])
    s.add_dependency(%q<bugsnag>, ["~> 2.0.3"])
    s.add_dependency(%q<bundler>, ["~> 1.10"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
  end
end
