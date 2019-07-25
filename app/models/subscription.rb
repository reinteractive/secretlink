class Subscription < ActiveRecord::Base
  PLANS = YAML.load_file(Rails.root.join("db", "data", "subscription_plans.yml"))

  enum status: [:active, :inactive]
end
