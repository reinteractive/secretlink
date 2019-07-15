# TODO: Handle data persistence
class SubscriptionService
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def perform(source_id)
    customer = create_customer(source_id)
    result = subscribe_to_plan(customer["id"])
    raise result.inspect
  end

  private

  def create_customer(source_id)
    Stripe::Customer.create({
      email: user.email,
      source: source_id
    })
  end

  def subscribe_to_plan(customer_id)
    Stripe::Subscription.create({
      customer: customer_id,
      items: [{
        plan: Rails.configuration.topsekrit_stripe_subscription_plan_id
      }],
    })
  end
end
