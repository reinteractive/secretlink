# OpsCare Gem

## Gist
[OpsCare](https://reinteractive.net/service/ops-care) is Ruby on Rails Operations as a Service by [reinteractive](https://reinteractive.net/).

We use this gem to ensure the correct installation of a few OpsCare dependencies such as Bugsnag, Skylight and OkComputer and provide a handy generator for the initial setup, according to our OpsCare conventions.

## Installation

Add this line to the application's Gemfile:

```ruby
gem 'ops_care', :git => 'git@github.com:reinteractive/OpsCare.git', :branch => 'master'
```

And then bundle all the things:

```bash
$ bundle
```

## Usage

To use the generator, from the app's root directory, run:

```bash
$ bundle exec rails g ops_care:setup
```

During setup the generator will:

- Generate Skylight's yml config file
- Add Skylight's config to application.rb
- Add Bugsnag initializer
- Add OkComputer initializer
- Add deploy hooks for our OpsCare "Tracks" deployment system

Most will have sensible defaults and don't need any customization because our stacks use envvars.

Deploy hooks will need to be tailored to the application's need and will be found in the `deploy_hooks` directory.

