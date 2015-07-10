# OaaS Sentinel Deploy Hooks

See the [Tracks README](https://github.com/reInteractive/reinteractive-stack/blob/develop/roles/tracks/README.md) for more information about the global hook mechanism. This readme is more specifically about the templates and how to add them to an app. 

When adapting an app to be hosted on OpsCare, one task is to ensure deployments hooks are present and configured.
Each hook sources the `services/load.sh` file, which in turn loads **all** services methods and helpers.
You can then have the hooks call the desired ones.

Design is not dry, and sourcing could be moved to Tracks itself, but it is not.
It is so to allow for maximum flexibility.

### Methodology
To prepare an app:

- Copy the whole `hooks/` directoy into the `config/` directory of the app.
- Configure and edit the hooks you need
- Remove all the unnecessary hooks (not mandatory, but definitely cleaner)

Most certainly, you will need the `after_deploy` hook, responsible for restarting the services and app.
It is the only template that is not fully commented out. A few other have some examples too.

### Hooks Anatomy

Typically, a hook will always begin with:
```shell
#!/bin/bash

# Loading all the services helpers.
# Don't touch this line
. ${current_app_path}/config/deploy/hooks/services/load.sh
```

Then, depending one the needs of the hook, it will continue like:

```shell

# Call a service method
zdd_unicorn

# Set Whenever cron jobs
[[ -f "${current_app_path}/bin/whenever" ]] && \
  cd ${current_app_path} && ./bin/whenever --write-crontab

# Creating a required directory
mkdir -p ${this_release_dir}/vendor/assets/javascript

# running a rake task
bundle exec rake bower:install
```

Since the hooks are called by the Tracks script, they have access to all variables and methods defined by the script.
See the source to figure behaviors. The most notable ones are:

```shell
# Usual variables
$APP_NAME
$FRAMEWORK_ENV
$APP_REPO
$app_full_name
$app_dir
$git_cached_copy
$release_app_path
$current_app_path
$shared_app_path
$previous_release
$first_deploy
$this_release_dir

# and Method
log
verb
log_and_verb
debug
raise
ensure
```


### Good Practices
When creating a scripts inside a hook, try to
- make them resilient to error in general, specifically file presence/absence
- have just the right amount of verbosity
- prefer log_and_verb method to a simple echo. AS the name suggest, it will also take care of logging to a local file.

### The Hooks

The list and order is as follow:

1. `before_check` before checking if the app has been updated.
1. `after_check` after checking if the app has been updated.
1. `before_deploy` before starting to work. This is the one you'd want to use to stop or alert services of the deploy.
1. `before_pull` before pulling the code.
1. `after_pull` after pulling the code.
1. `before_release` before copying the pulled directory into the release directory.
1. `after_release` after copying the pulled directory into the release directory.
1. `before_bundle` before trying to bundle. *It will be called whether there is actually a need to bundle or not*.
1. `after_bundle` after trying to bundle. *It will be called whether there is actually a need to bundle or not*.
1. `before_migrate` before trying to migrate. *It will be called whether there is actually a need to migrate or not*.
1. `after_migrate` after trying to migrate. *It will be called whether there is actually a need to migrate or not*.
1. `before_assets` before trying to compile assets. *It will be called whether there is actually a need to compile or not*.
1. `after_assets` after trying to compile assets. *It will be called whether there is actually a need to compile or not*.
1. `before_symlink` before symlimking the release to the `current` location.
1. `after_symlink` after symlimking the release to the `current` location.
1. `after_deploy` after doing most of the work.  
1. `before_health_check` before performing the health check.
1. `after_health_check` after performing the health check.
1. `before_rollback` **in case of failed health check**, before rolling back.
1. `after_rollback` **in case of failed health check**, after rolling back.
1. `before_cleanup` before cleaning up older release directories.
1. `after_cleanup` after cleaning up older release directories.
1. `after_all` Done.

