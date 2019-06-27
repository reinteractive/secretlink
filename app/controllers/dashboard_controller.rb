class DashboardController < AuthenticatedController
  def index
    @secrets = current_user.secrets.order(created_at: :desc).last(10)
  end
end
