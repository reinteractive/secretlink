class DashboardController < AuthenticatedController
  def index
    @secrets = current_user.secrets
  end
end
