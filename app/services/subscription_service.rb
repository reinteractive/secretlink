require 'ostruct'

class SubscriptionService
  attr_reader :user, :plan

  def initialize(user)
    @user = user

    # Right now we're just supporting 1 type of plan
    @plan = OpenStruct.new(Subscription::PLANS['default_monthly'])
  end

  def perform(source_id)
    customer = create_customer(source_id)

    # TODO: Use same customer id when present
    # Or Persist if customer is new
    result = subscribe_to_plan(customer["id"])

    # TODO:
    # Persist subscription
    build_subscription(result)
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
        plan: plan.stripe_id
      }],
    })
  end

  def build_subscription(stripe_subscription)
    # TODO: Handle failure
    if stripe_subscription.status == "active"
      Subscription.create!(
        code: plan.code,
        status: :active,
        cached_metadata: plan.to_h,
        cached_transaction_details: stripe_subscription.to_json
      )
    end
  end
end
