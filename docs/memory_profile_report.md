### Memory Profiling Report

Memory Profiling was executed using `derailed_benchmarks` gem.

Gem load profiling report

```
TOP: 146.3906 MiB
  rails/all: 61.3281 MiB
    action_mailbox/engine: 33.3438 MiB
      action_mailbox: 33.3281 MiB
        action_mailbox/mail_ext: 33.2656 MiB
          action_mailbox/mail_ext/address_equality.rb: 30.2344 MiB
            mail/elements/address: 30.2344 MiB
              mail/parsers/address_lists_parser: 30.2188 MiB
          mail: 3.0313 MiB
            mail/field: 1.5313 MiB
              mail/fields/resent_bcc_field: 1.2656 MiB
            net/smtp: 0.4531 MiB
              net/protocol: 0.3281 MiB (Also required by: net/http)
    rails: 16.1406 MiB (Also required by: active_record/railtie, active_model/railtie, and 13 others)
      rails/application: 14.9219 MiB
        active_support/encrypted_configuration: 6.2344 MiB
          active_support/encrypted_file: 6.1875 MiB
            active_support/message_encryptor: 5.6563 MiB
              active_support/messages/codec: 5.6094 MiB (Also required by: active_support/message_verifier)
                /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-8.0.1/lib/active_support/messages/metadata: 5.6094 MiB
                  active_support/json: 5.6094 MiB
                    active_support/json/encoding: 5.3594 MiB
                      active_support/core_ext/object/json: 5.3438 MiB (Also required by: active_support/core_ext/object)
                        active_support/core_ext/time/conversions: 4.7813 MiB (Also required by: active_support/core_ext/date_time/conversions, active_support/core_ext/time/calculations)
                          active_support/values/time_zone: 4.75 MiB (Also required by: active_support/core_ext/date_time/conversions, active_support/time_with_zone)
                            tzinfo: 4.6719 MiB
                              /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/tzinfo-2.0.6/lib/tzinfo/string_deduper: 2.8594 MiB
                                concurrent: 2.8594 MiB (Also required by: /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/tzinfo-2.0.6/lib/tzinfo/data_source, sprockets/manifest)
                                  concurrent/configuration: 0.6406 MiB (Also required by: concurrent/scheduled_task, concurrent/options, and 3 others)
                                    concurrent/delay: 0.4844 MiB (Also required by: concurrent/utility/processor_counter, concurrent)
                                      concurrent/concern/obligation: 0.4375 MiB (Also required by: concurrent/ivar)
                                        concurrent/atomic/event: 0.3125 MiB (Also required by: concurrent/executor/immediate_executor, concurrent/executor/ruby_thread_pool_executor, and 4 others)
                                  concurrent/atomics: 0.5938 MiB
                                    concurrent/atomic/reentrant_read_write_lock: 0.4531 MiB
                                  concurrent/promises: 0.4688 MiB
                              /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/tzinfo-2.0.6/lib/tzinfo/data_sources/posix_time_zone_parser: 1.2656 MiB
                        uri/generic: 0.4219 MiB (Also required by: global_id/uri/gid)
                          /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/uri-1.0.3/lib/uri/common: 0.3125 MiB (Also required by: uri)
            tempfile: 0.5156 MiB (Also required by: rack/utils, /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rack-test-2.2.0/lib/rack/test/uploaded_file)
              tmpdir: 0.4531 MiB (Also required by: execjs/external_runtime, /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/unicorn-6.1.0/lib/unicorn/tmpio)
        active_support/key_generator: 6.0 MiB
          openssl: 6.0 MiB (Also required by: active_support/message_encryptor, active_support/message_verifier, and 8 others)
            openssl.so: 2.7813 MiB
            /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/3.2.0/openssl/ssl: 2.7031 MiB
              ipaddr: 0.7969 MiB (Also required by: active_support/core_ext/object/json, ssrf_filter/ssrf_filter, and 2 others)
                socket: 0.5313 MiB (Also required by: /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/3.2.0/openssl/ssl, net/protocol, and 9 others)
        active_support/deprecation: 1.0156 MiB (Also required by: active_support/rails, active_record/errors)
          active_support/deprecation/behaviors: 0.6094 MiB
            active_support/notifications: 0.5469 MiB (Also required by: /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/activesupport-8.0.1/lib/active_support/messages/serializer_with_fallback, active_support/subscriber)
              active_support/notifications/fanout: 0.3906 MiB
        yaml: 0.8438 MiB (Also required by: active_support/encrypted_configuration, active_record, and 10 others)
          psych: 0.8438 MiB
            /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/psych-5.2.3/lib/psych/visitors: 0.3906 MiB
        rails/engine: 0.5313 MiB
      active_support: 0.875 MiB (Also required by: active_support/railtie, active_support/i18n_railtie, and 17 others)
        active_support/dependencies/autoload: 0.5313 MiB (Also required by: web_console)
          active_support/inflector/methods: 0.5313 MiB (Also required by: active_support/core_ext/time/conversions, active_support/core_ext/date_time/conversions, and 5 others)
            active_support/inflections: 0.5156 MiB (Also required by: active_support/inflector)
              active_support/inflector/inflections: 0.4531 MiB (Also required by: active_support/inflector)
                active_support/i18n: 0.4219 MiB (Also required by: active_support/inflector/transliterate, abstract_controller)
                  i18n: 0.375 MiB
    active_record/railtie: 4.9844 MiB (Also required by: active_storage/engine, action_mailbox/engine)
      active_record: 2.5 MiB (Also required by: active_storage)
        arel: 0.7813 MiB
          arel/nodes: 0.3125 MiB
        active_record/errors: 0.4688 MiB
          active_model/errors: 0.3125 MiB
        active_record/migration: 0.4063 MiB
      action_controller/railtie: 2.4063 MiB (Also required by: active_storage/engine, rails/all, and 3 others)
        action_controller: 1.4063 MiB
          action_controller/metal/strong_parameters: 1.2656 MiB
            rack/test: 0.8438 MiB
              uri: 0.3281 MiB (Also required by: /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rack-test-2.2.0/lib/rack/test/cookie_jar, rack/utils, and 22 others)
        action_view/railtie: 0.9375 MiB (Also required by: rails/all)
          action_dispatch/routing/route_set: 0.5625 MiB
            action_dispatch/journey: 0.375 MiB
    active_storage/engine: 2.3125 MiB (Also required by: action_mailbox/engine, action_text/engine)
      active_storage: 1.3438 MiB
        marcel: 1.2188 MiB (Also required by: carrierwave/sanitized_file)
          marcel/magic: 1.2188 MiB
            marcel/tables: 1.125 MiB
      active_job/railtie: 0.7813 MiB (Also required by: action_mailer/railtie, rails/all)
        global_id/railtie: 0.6563 MiB
          active_support/core_ext/integer/time: 0.5 MiB
            active_support/core_ext/numeric/time: 0.375 MiB (Also required by: active_storage, action_mailbox)
              active_support/core_ext/time/calculations: 0.375 MiB (Also required by: active_support/file_update_checker)
    action_text/engine: 2.1719 MiB
      action_text: 2.1719 MiB
        nokogiri: 2.1406 MiB (Also required by: loofah, TOP)
          /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/nokogiri-1.18.3/lib/nokogiri/extension: 0.4844 MiB (Also required by: /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/nokogiri-1.18.3/lib/nokogiri/version/info)
            nokogiri/nokogiri: 0.4844 MiB
          /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/nokogiri-1.18.3/lib/nokogiri/encoding_handler: 0.4688 MiB
          /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/nokogiri-1.18.3/lib/nokogiri/xml: 0.4063 MiB
          /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/nokogiri-1.18.3/lib/nokogiri/html4: 0.3906 MiB (Also required by: /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/nokogiri-1.18.3/lib/nokogiri/html)
    rails/test_unit/railtie: 1.9063 MiB
      rails/test_unit/line_filtering: 1.9063 MiB
        rails/test_unit/runner: 1.9063 MiB
          rails/test_unit/test_parser: 1.0156 MiB
            ripper: 0.9844 MiB (Also required by: rails/source_annotation_extractor)
              ripper/sexp: 0.5 MiB
          rake/file_list: 0.7656 MiB
    action_cable/engine: 0.4531 MiB
      action_cable: 0.3594 MiB
  rubocop: 25.0469 MiB (Also required by: rubocop-performance, rubocop-rails)
    rubocop-ast: 10.0 MiB
      /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rubocop-ast-1.38.1/lib/rubocop/ast: 10.0 MiB
        parser: 9.0781 MiB
          /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/parser-3.3.7.1/lib/parser/lexer-F1: 8.4375 MiB
    regexp_parser: 1.5469 MiB
      /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/regexp_parser-2.10.0/lib/regexp_parser/parser: 0.6563 MiB
        /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/regexp_parser-2.10.0/lib/regexp_parser/expression: 0.5 MiB
      /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/regexp_parser-2.10.0/lib/regexp_parser/scanner: 0.5469 MiB
    /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rubocop-1.31.0/lib/rubocop/options: 0.4063 MiB
      optparse: 0.3281 MiB
    /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rubocop-1.31.0/lib/rubocop/cop/commissioner: 0.375 MiB
  better_errors: 19.7031 MiB
    better_errors/code_formatter: 19.0 MiB
      better_errors/code_formatter/html: 18.9844 MiB
        rouge: 18.9688 MiB (Also required by: better_errors/error_page)
          /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rouge-4.3.0/lib/rouge/lexers/openedge.rb: 0.7813 MiB
          /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rouge-4.3.0/lib/rouge/lexers/irb.rb: 0.5781 MiB
            /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rouge-4.3.0/lib/rouge/lexers/ruby.rb: 0.5313 MiB (Also required by: rouge)
          /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rouge-4.3.0/lib/rouge/lexers/crystal.rb: 0.5469 MiB
          /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rouge-4.3.0/lib/rouge/lexers/plsql.rb: 0.5 MiB
          /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rouge-4.3.0/lib/rouge/lexers/ruby.rb: 0.4219 MiB (Also required by: /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rouge-4.3.0/lib/rouge/lexers/irb.rb)
          /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rouge-4.3.0/lib/rouge/lexers/bsl.rb: 0.3594 MiB
  rubocop-rails: 12.4375 MiB
    /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rubocop-rails-2.15.2/lib/rubocop/cop/rails_cops: 10.2188 MiB
      /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rubocop-rails-2.15.2/lib/rubocop/cop/rails/redundant_presence_validation_on_belongs_to: 0.625 MiB
      /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rubocop-rails-2.15.2/lib/rubocop/cop/rails/index_by: 0.3594 MiB
    /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rubocop-rails-2.15.2/lib/rubocop/rails: 0.3906 MiB
  sassc-rails: 5.1406 MiB
    /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/sassc-rails-2.1.2/lib/sassc/rails: 5.1406 MiB
      sassc: 2.5156 MiB
        /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/sassc-2.4.0/lib/sassc/native: 2.1719 MiB
      /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/sassc-rails-2.1.2/lib/sassc/rails/railtie: 1.6094 MiB
        sprockets/railtie: 1.5781 MiB
          sprockets: 1.0469 MiB (Also required by: sprockets/rails/context, sprockets/rails/helper)
      /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/sassc-rails-2.1.2/lib/sassc/rails/importer: 0.4688 MiB
        tilt: 0.4063 MiB
  rubocop-performance: 4.8906 MiB
    /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rubocop-performance-1.19.1/lib/rubocop/cop/performance_cops: 2.1719 MiB
  omniauth-google-oauth2: 3.75 MiB
    omniauth/google_oauth2: 3.75 MiB
      omniauth/strategies/google_oauth2: 3.75 MiB
        oauth2: 2.9063 MiB (Also required by: omniauth/strategies/oauth2)
          oauth2/client: 2.1719 MiB
            faraday: 2.0625 MiB
              faraday/response: 0.5781 MiB
                faraday/response/logger: 0.4844 MiB
                  faraday/logging/formatter: 0.3906 MiB
                    pp: 0.3281 MiB (Also required by: better_errors)
          snaky_hash: 0.3906 MiB
        omniauth/strategies/oauth2: 0.3906 MiB
        jwt: 0.3594 MiB (Also required by: oauth2/strategy/assertion)
  skylight: 2.5781 MiB (Also required by: skylight/railtie)
    skylight/config: 1.5156 MiB
      skylight/util/deploy: 1.4375 MiB
    skylight/native: 0.5781 MiB
  simple_form: 2.375 MiB
    simple_form/action_view_extensions/builder: 2.1406 MiB
      action_view/helpers: 2.1406 MiB (Also required by: sprockets/rails/context)
        action_view/helpers/sanitize_helper: 0.8125 MiB (Also required by: action_view/helpers/text_helper)
          rails-html-sanitizer: 0.7969 MiB
            loofah: 0.6406 MiB
  carrierwave: 1.9063 MiB
    carrierwave/uploader: 1.5781 MiB
      carrierwave/uploader/configuration: 1.1875 MiB
        carrierwave/downloader/base: 1.1875 MiB
          addressable: 0.5625 MiB
            addressable/uri: 0.4375 MiB (Also required by: addressable/template)
          ssrf_filter: 0.5469 MiB
            ssrf_filter/ssrf_filter: 0.5469 MiB
              net/http: 0.4844 MiB (Also required by: recaptcha, skylight/util/http)
  pg: 1.7656 MiB
    pg_ext: 1.6406 MiB
  bugsnag: 1.375 MiB
    bugsnag/configuration: 0.4375 MiB
  unicorn: 0.8125 MiB
  jbuilder: 0.7969 MiB
    jbuilder/railtie: 0.6406 MiB
      jbuilder/jbuilder_template: 0.625 MiB
        jbuilder/collection_renderer: 0.5313 MiB
          action_view/renderer/collection_renderer: 0.4844 MiB
            action_view/renderer/partial_renderer: 0.4688 MiB
  simplecov: 0.6406 MiB
  listen: 0.4063 MiB (Also required by: spring/watcher/listen)
    listen/listener: 0.4063 MiB
```

With files in app.

Output for the report of: `RAILS_ENV=development bundle exec derailed exec mem`

```
Booting: development
Database 'topsekrit_development' already exists
Database 'topsekrit_test' already exists
Method: GET
Endpoint: "/"
## Impact of `require <file>` on RAM

Showing all `require <file>` calls that consume 0.3 MiB or more of RSS
Configure with `CUT_OFF=0` for all entries or `CUT_OFF=5` for few entries
Note: Files only count against RAM on their first load.
      If multiple libraries require the same file, then
       the 'cost' only shows up under the first library

TOP: 95.3906 MiB
  application: 71.7344 MiB
    rubocop: 26.0156 MiB (Also required by: rubocop-performance, rubocop-rails)
      rubocop-ast: 7.25 MiB
        /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rubocop-ast-1.38.1/lib/rubocop/ast: 7.25 MiB
          parser: 6.6094 MiB
            /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/parser-3.3.7.1/lib/parser/lexer-F1: 3.0156 MiB
            /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/parser-3.3.7.1/lib/parser/lexer-strings: 2.7656 MiB
      regexp_parser: 1.4219 MiB
        /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/regexp_parser-2.10.0/lib/regexp_parser/parser: 0.7188 MiB
          /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/regexp_parser-2.10.0/lib/regexp_parser/expression: 0.5625 MiB
        /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/regexp_parser-2.10.0/lib/regexp_parser/scanner: 0.375 MiB
      /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rubocop-1.31.0/lib/rubocop/cop/style/zero_length_predicate: 0.5 MiB
      /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rubocop-1.31.0/lib/rubocop/runner: 0.4844 MiB
        parallel: 0.3281 MiB
      /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rubocop-1.31.0/lib/rubocop/cop/style/redundant_sort: 0.3906 MiB
      /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rubocop-1.31.0/lib/rubocop/config: 0.3594 MiB
      /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rubocop-1.31.0/lib/rubocop/cop/style/redundant_parentheses: 0.3125 MiB
    better_errors: 18.1406 MiB
      better_errors/code_formatter: 17.6563 MiB
        better_errors/code_formatter/html: 17.6563 MiB
          rouge: 17.6563 MiB (Also required by: better_errors/error_page)
            /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rouge-4.3.0/lib/rouge/lexers/irb.rb: 0.6406 MiB
              /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rouge-4.3.0/lib/rouge/lexers/ruby.rb: 0.5313 MiB (Also required by: rouge)
            /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rouge-4.3.0/lib/rouge/lexers/crystal.rb: 0.4531 MiB
            /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rouge-4.3.0/lib/rouge/lexers/igorpro.rb: 0.4531 MiB
            /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rouge-4.3.0/lib/rouge/lexers/ruby.rb: 0.4063 MiB (Also required by: /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rouge-4.3.0/lib/rouge/lexers/irb.rb)
            /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rouge-4.3.0/lib/rouge/lexers/bsl.rb: 0.3594 MiB
    sassc-rails: 4.7656 MiB
      /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/sassc-rails-2.1.2/lib/sassc/rails: 4.7656 MiB
        sassc: 2.3594 MiB
          /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/sassc-2.4.0/lib/sassc/native: 2.25 MiB
        /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/sassc-rails-2.1.2/lib/sassc/rails/railtie: 1.9063 MiB
          sprockets/railtie: 1.9063 MiB
            sprockets: 1.6719 MiB (Also required by: sprockets/rails/context, sprockets/rails/helper)
              sprockets/environment: 0.5313 MiB
                sprockets/base: 0.5313 MiB (Also required by: sprockets/cached_environment)
    omniauth-google-oauth2: 2.875 MiB
      omniauth/google_oauth2: 2.875 MiB
        omniauth/strategies/google_oauth2: 2.875 MiB
          oauth2: 1.5938 MiB (Also required by: omniauth/strategies/oauth2)
            oauth2/client: 0.8906 MiB
              faraday: 0.7656 MiB
            snaky_hash: 0.5469 MiB
          jwt: 0.9531 MiB (Also required by: oauth2/strategy/assertion)
            jwt/jwk: 0.3438 MiB
            jwt/encode: 0.3438 MiB
    rubocop-rails: 2.625 MiB
      /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rubocop-rails-2.15.2/lib/rubocop/cop/rails_cops: 2.0156 MiB
    carrierwave: 2.4688 MiB
      carrierwave/uploader: 2.1406 MiB
        carrierwave/uploader/configuration: 1.7031 MiB
          carrierwave/downloader/base: 1.6875 MiB
            ssrf_filter: 1.0 MiB
              ssrf_filter/ssrf_filter: 1.0 MiB
                net/http: 0.9375 MiB (Also required by: recaptcha, skylight/util/http)
                  resolv: 0.5938 MiB (Also required by: ssrf_filter/ssrf_filter, /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/rubocop-1.31.0/lib/rubocop/cop/style/ip_addresses)
            addressable: 0.6719 MiB
              addressable/uri: 0.5938 MiB (Also required by: addressable/template)
    simple_form: 2.375 MiB
      simple_form/action_view_extensions/builder: 1.8438 MiB
        action_view/helpers: 1.8438 MiB (Also required by: sprockets/rails/context, action_view/base)
          action_view/helpers/tag_helper: 0.4219 MiB (Also required by: action_view/helpers/url_helper, action_view/helpers/text_helper, and 4 others)
          action_view/helpers/sanitize_helper: 0.375 MiB (Also required by: action_view/helpers/text_helper)
            rails-html-sanitizer: 0.375 MiB (Also required by: /Users/sumanawal/.asdf/installs/ruby/3.2.2/lib/ruby/gems/3.2.0/gems/actiontext-8.0.1/app/helpers/action_text/content_helper.rb)
              loofah: 0.3438 MiB
    rubocop-performance: 2.3281 MiB
    pg: 1.9375 MiB (Also required by: active_record/connection_adapters/postgresql_adapter)
      pg_ext: 1.6563 MiB
    skylight: 1.5156 MiB (Also required by: skylight/railtie)
      skylight/native: 0.5938 MiB
    jbuilder: 1.1875 MiB
      jbuilder/railtie: 1.1094 MiB
        jbuilder/jbuilder_template: 1.1094 MiB
          jbuilder/collection_renderer: 0.875 MiB
            action_view/renderer/collection_renderer: 0.8594 MiB
              action_view/renderer/partial_renderer: 0.8281 MiB
                active_support/cache: 0.5625 MiB (Also required by: jbuilder/jbuilder_template)
    okcomputer: 0.7969 MiB
    unicorn: 0.6875 MiB
    uglifier: 0.5938 MiB
      execjs: 0.4531 MiB
        execjs/runtimes: 0.4531 MiB
    simplecov: 0.5781 MiB
    bugsnag: 0.5469 MiB
    logstasher: 0.4219 MiB
    listen: 0.4063 MiB (Also required by: spring/watcher/listen, active_support/evented_file_update_checker)
      listen/listener: 0.4063 MiB
    puma: 0.375 MiB
  active_record/base: 8.1406 MiB
    active_record/connection_adapters/postgresql_adapter: 4.7969 MiB
      active_record/connection_adapters/postgresql/schema_statements: 3.1406 MiB
      active_record/connection_adapters/abstract_adapter: 0.5625 MiB
      active_record/connection_adapters/postgresql/schema_definitions: 0.3438 MiB
      active_record/connection_adapters/postgresql/oid: 0.3281 MiB
    active_record/querying: 0.4219 MiB
    active_record/enum: 0.3438 MiB
      active_record/type: 0.3438 MiB
  action_controller/base: 0.8906 MiB
  action_dispatch/routing/mapper: 0.75 MiB
  active_record/relation: 0.5313 MiB
  web_console/request: 0.5156 MiB
    action_dispatch/http/request: 0.4531 MiB
  simple_form/form_builder: 0.4219 MiB
  ```
