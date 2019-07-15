class SubscriptionsController < AuthenticatedController
  layout 'settings'

  def new
  end

  def create
    SubscriptionService.new(current_user)
      .perform(params[:stripe_source])
  end
end
