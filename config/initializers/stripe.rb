require "stripe"

Rails.application.config.after_initialize do
  Stripe.api_key = Rails.configuration.topsekrit_stripe_secret_key
end
