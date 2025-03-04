secretlink.org
==============================================

_An application that facilitates sharing secrets._

[![Test Coverage](https://codeclimate.com/repos/5848e0abc73d236cfb0008a6/badges/3092c9a55640812a1290/coverage.svg)](https://codeclimate.com/repos/5848e0abc73d236cfb0008a6/coverage)
[![Code Climate](https://codeclimate.com/repos/5848e0abc73d236cfb0008a6/badges/3092c9a55640812a1290/gpa.svg)](https://codeclimate.com/repos/5848e0abc73d236cfb0008a6/feed)

Sharing of passwords, keys, and files can be difficult to perform securely. This
application allows a secret to be shared and viewed via a unique url. After the
secret is viewed once, it is deleted.

secretlink.org is available for anyone to use at [https://secretlink.org/](https://secretlink.org/),
it is a Ruby on Rails application created and built by [reinteractive](https://reinteractive.com/)
and hosted through reinteractive's [OpsCare service](https://reinteractive.com/service/ops-care).
It has been made open source to ensure transparency on the service and to encourage contribution
to improve the security of the application.

All pull requests welcome.

If you do not want to (or can not) use our hosted version, you are welcome to run
your own version for your own company or organisation, we only stipulate that you
may not run it as a service for third parties in competition to https://secretlink.org/


The typlical workflow:
---------------------------

- Someone visits [https://secretlink.org/](https://secretlink.org/) and enters their email
  address and the recipient's email address. The recipient's email address isn't strictly necessary at this point but it reduces confusion for non-technical users.
- An email link with a one-time authentication token is sent to the email.
- They follow the link to a form where they can enter the secret info that they want
  to share. The recipient's email address will automatically be filled in if it was provided when creating the auth token.
- The secret is encrypted with a one time key, the encrypted secret is stored on the
  server without the key.
- A link to decrypt the secret is sent to the recipient's email address including the
  one time decryption key which is not stored on server.
- The recipient views the secret and the encrypted version is deleted from the
  database.
- A note is emailed to the sender saying the secret has been read.


Required Environment / Minimum Setup
----------------------------------------------

* Ruby version 3.2.2
* Any ActiveRecord supported database (must support large multi megabyte text fields)

To setup the system locally, do the following:

- Copy the `.env.example` file in Rails root to `.env`
- Configure `Recaptcha` in [reCAPTCHA admin console](https://www.google.com/recaptcha/admin) and update the environment variable.
- Copy the `config/database.example.yml` file to `config/database.yml` and edit
  appropriately
- Run `./bin/setup`
- Start the Rails server with `foreman start -f Procfile.dev`

Once done, specs should pass by running the `rake` command and you should get
the secretlink.org app in your browser at http://localhost:3000/

As one of the main interfaces to this application is emails, it is a good idea to run
MailCatcher:

```bash
# First install Mailcatcher
# (it is not in the Gemfile -- and not supposed to be per http://mailcatcher.me/)
gem install mailcatcher

# Launch the Mailcatcher server and browse to `http://127.0.0.1:1080` to
# see the emails sent by the system:
mailcatcher
```


Configuration
----------------------------------------------

Configuration options are stored in config/initializers/topsekrit.rb, and can
be used to:

- Restrict creation of secrets to email addresses from certain domains.
- Restrict sharing of secrets to email addresses from certain domains.
- Set a maximum expiry time for secrets.
- Set the Google OAuth2 configuration.


Walkthrough / Smoke Test
----------------------------------------------

Once running, with mailcatcher on your local box, you should be able to send a
secret to yourself.

- Go to http://127.0.0.1:3000/ and enter an email address.
- Follow the link emailed to you (which you will see in the mailcatcher
  browser on http://127.0.0.1:1080,
- Enter a secret and recipient details and send it
- Follow the link emailed to the second email address (which you will see
  in the mailcatcher browser on http://127.0.0.1:1080
- View the secret
- See the confirmation email that the secret has been read in the mailcatcher
  browser


Testing
----------------------------------------------

Tests will run, once setup with `rspec spec` or simply `rake`. All tests in
master and develop should pass at all times.


Staging Environment
----------------------------------------------

The staging environment is hosted on Heroku.

Access it at [staging.secretlink.org](https://satging.secretlink.org/)

To deploy to staging, push the master branch to heroku git repository:

    First get invite to repo from Ops Staff
    git remote add staging https://git.heroku.com/rei-secretlink-staging.git
    git push staging develop:master

To test sending emails, you must validate any recepient emails first,
using the sandbox domain in the mailgun control panel on the Heroku Dasboard.

Production Environment
----------------------------------------------

The production environment is hosted on Heroku.

Access it at [secretlink.org](https://secretlink.org/)

To deploy to production, push the master branch to heroku git repository:

    First get invite to repo from Ops Staff
    git remote add production https://git.heroku.com/rei-secretlink-production.git
    git push production master:master

These should automatic run, but if they didnt and are needed then:

    heroku run rake assets:precompile -a rei-secretlink-production
    heroku run rake db:migrate -a rei-secretlink-production

Some helpful commands:

    heroku restart -a rei-secretlink-production
    heroku logs --tail -a rei-secretlink-production

