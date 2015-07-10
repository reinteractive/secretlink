# Opscare

## Gist
[Opscare](https://reinteractive.net/service/ops-care) is Operation as a Service by _reinteractive_.

This gem ensure presence of a few dependencies (Bugsnag, Skylight, OkComputer) and provides a handy generator for the initial setups, according to our conventions and stacks.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'opscare'
```

And then execute:

```bash
$ bundle
```

## Usage

To use the generator, from your app's root directory, run:

```bash
$ bundle exec rails g opscare:setup
```

It try to:

- Generate Skylight's yml config file
- Add Skylight's config to application.rb
- Add Bugsnag initializer
- Add OkComputer initializer
- Add Tracks deploy hooks

Most will have sensible defaults and don't need any customization because our stacks use envvars.

Tracks deploy hooks will need to be tailored to the application's need.

