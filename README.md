# SnapSecret

_An application that facilitates sharing secrets._

Sharing of passwords, keys, and files can be difficult to perform securely. This application allows a secret to be shared and viewed via a unique url. After the secret is viewed once, it is deleted.

Configuration options are stored in config/initializers/snapsecret.rb, and can be used to:

- Restrict creation of secrets to email addresses from certain domains.
- Allow various oauth providers to authenticate when creating a secret

The typical workflow is:

- Someone visits the site and enters their email address.
- An email link with a one-time authentication token is sent to them.
- They follow the link to a form where they can enter the secret info that they want to share, including the recipient's email address.
- A link to the secret is sent to the recipient's email address.
- The recipient views the secret and it is deleted from the database.


## Dev Setup
System is pretty vanilla.

One of the main interfaces of the app is emails.
To test emails, we use mailcatcher.

To setup on your machine:

```bash
# Create the database.yml file:
cp config/database.example.yml database.yml
# And adapt it to your environment. Default uses postgres.

# Run bundler
bundle install
# Setup the database
bundle exec rake db:setup
# Launch the server
bundle exec rail server
```

For Mailcatcher:

```bash
# in another Terminal window
# Install Mailcatcher
# (it is not in the Gemfile -- and not supposed to be)
gem install mailcatcher

# Launch the Mailcatcher server
# (You can daemonize with `mailcatcher -f`)
# Browse to `http://127.0.0.1:1080` to get the incoming emails
mailcatcher
```
