# -*- encoding: utf-8 -*-
# stub: ops_care 1.0.4 ruby lib

Gem::Specification.new do |s|
  s.name = "ops_care".freeze
  s.version = "1.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Glenn Davy".freeze, "Joseph Glanville".freeze, "Mikel Lindsaar".freeze, "Raphael Campardou".freeze, "Tim Hemi".freeze]
  s.bindir = "exe".freeze
  s.date = "2017-03-07"
  s.email = ["support@reinteractive.net".freeze]
  s.files = [".gitignore".freeze, "Gemfile".freeze, "LICENSE.md".freeze, "README.md".freeze, "Rakefile".freeze, "bin/console".freeze, "bin/setup".freeze, "lib/generators/ops_care/setup_generator.rb".freeze, "lib/generators/ops_care/templates/bugsnag.rb".freeze, "lib/generators/ops_care/templates/deploy_hooks/README.md".freeze, "lib/generators/ops_care/templates/deploy_hooks/after_all.sh".freeze, "lib/generators/ops_care/templates/deploy_hooks/after_assets.sh".freeze, "lib/generators/ops_care/templates/deploy_hooks/after_bundle.sh".freeze, "lib/generators/ops_care/templates/deploy_hooks/after_check.sh".freeze, "lib/generators/ops_care/templates/deploy_hooks/after_cleanup.sh".freeze, "lib/generators/ops_care/templates/deploy_hooks/after_deploy.sh".freeze, "lib/generators/ops_care/templates/deploy_hooks/after_health_check.sh".freeze, "lib/generators/ops_care/templates/deploy_hooks/after_migrate.sh".freeze, "lib/generators/ops_care/templates/deploy_hooks/after_pull.sh".freeze, "lib/generators/ops_care/templates/deploy_hooks/after_release.sh".freeze, "lib/generators/ops_care/templates/deploy_hooks/after_rollback.sh".freeze, "lib/generators/ops_care/templates/deploy_hooks/after_symlink.sh".freeze, "lib/generators/ops_care/templates/deploy_hooks/before_assets.sh".freeze, "lib/generators/ops_care/templates/deploy_hooks/before_bundle.sh".freeze, "lib/generators/ops_care/templates/deploy_hooks/before_check.sh".freeze, "lib/generators/ops_care/templates/deploy_hooks/before_cleanup.sh".freeze, "lib/generators/ops_care/templates/deploy_hooks/before_deploy.sh".freeze, "lib/generators/ops_care/templates/deploy_hooks/before_health_check.sh".freeze, "lib/generators/ops_care/templates/deploy_hooks/before_migrate.sh".freeze, "lib/generators/ops_care/templates/deploy_hooks/before_pull.sh".freeze, "lib/generators/ops_care/templates/deploy_hooks/before_release.sh".freeze, "lib/generators/ops_care/templates/deploy_hooks/before_rollback.sh".freeze, "lib/generators/ops_care/templates/deploy_hooks/before_symlink.sh".freeze, "lib/generators/ops_care/templates/deploy_hooks/services/delayed-job-service.sh".freeze, "lib/generators/ops_care/templates/deploy_hooks/services/load.sh".freeze, "lib/generators/ops_care/templates/deploy_hooks/services/puma-service.sh".freeze, "lib/generators/ops_care/templates/deploy_hooks/services/pushr-service.sh".freeze, "lib/generators/ops_care/templates/deploy_hooks/services/resque-service.sh".freeze, "lib/generators/ops_care/templates/deploy_hooks/services/sidekiq-service.sh".freeze, "lib/generators/ops_care/templates/deploy_hooks/services/unicorn-service.sh".freeze, "lib/generators/ops_care/templates/deploy_hooks/services/whenever-service.sh".freeze, "lib/generators/ops_care/templates/okcomputer.rb".freeze, "lib/generators/ops_care/templates/rake_tasks/opscare_data_mangling.rake".freeze, "lib/generators/ops_care/templates/skylight.yml".freeze, "lib/ops_care.rb".freeze, "lib/ops_care/version.rb".freeze, "ops_care.gemspec".freeze]
  s.homepage = "https://github.com/reinteractive/OpsCare".freeze
  s.rubygems_version = "2.6.10".freeze
  s.summary = "Configuration and support for reinteractive's OpsCare service.".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<skylight>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<okcomputer>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<bugsnag>.freeze, [">= 0"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
    else
      s.add_dependency(%q<skylight>.freeze, [">= 0"])
      s.add_dependency(%q<okcomputer>.freeze, [">= 0"])
      s.add_dependency(%q<bugsnag>.freeze, [">= 0"])
      s.add_dependency(%q<bundler>.freeze, ["~> 1"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    end
  else
    s.add_dependency(%q<skylight>.freeze, [">= 0"])
    s.add_dependency(%q<okcomputer>.freeze, [">= 0"])
    s.add_dependency(%q<bugsnag>.freeze, [">= 0"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
  end
end
