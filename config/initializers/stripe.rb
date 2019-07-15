require "stripe"

Stripe.api_key = Rails.configuration.topsekrit_secret_key
