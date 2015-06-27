TopSekr.it
==============================================

_An application that facilitates sharing secrets._

Sharing of passwords, keys, and files can be difficult to perform securely. This
application allows a secret to be shared and viewed via a unique url. After the
secret is viewed once, it is deleted.

TopSekr.it is available for anyone to use at [https://topsekr.it/](https://topsekr.it/),
it is a Ruby on Rails application created and built by [reinteractive](https://reinteractive.net/)
and hosted thorugh reinteractive's [OpsCare service](https://reinteractive.net/service/ops-care).
It has been made open source to ensure transparency on the service and to encourage contribution
to improve the security of the application.

All pull requests welcome.

If you do not want to (or can not) use our hosted version, you are welcome to run
your own version for your own company or organisation, we only stipulate that you
may not run it as a service for third parties in competition to https://topsekr.it/


The typlical workflow:
---------------------------

- Someone visits [https://topsekr.it/](https://topsekr.it/) and enters their email
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

* Ruby version 2.2.2 (old versions of ruby supported)
* Any ActiveRecord supported database (must support large multi megabyte text fields)

To setup the system locally, do the following:

- Copy the `.env.example` file in Rails root to `.env`
- Copy the `config/database.example.yml` file to `config/database.yml` and edit
  appropriately
- Run `./bin/setup`
- Start the Rails server with `rails s`

Once done, specs should pass by running the `rake` command and you should get
the TopSekr.it app in your browser at http://127.0.0.1:3000/

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

TopSekr.it staging is deployed from the develop branch.

The environment is run with continuous development and continuous integration
on the [reinteractive OpsCare](https://reinteractive.net/service/ops-care)
service on top of AWS cloud.

Pushing to develop will automatically deploy to the CI servers and once green
will deploy to staging.


Production Environment
----------------------------------------------

TopSekr.it production is deployed from the master branch.

Once a known good realease is ready for deploy, deployment is done from the
command line with the standard OpsCare tools.

