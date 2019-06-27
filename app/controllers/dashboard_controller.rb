class DashboardController < AuthenticatedController
  def index
    @secrets = current_user.secrets.order(created_at: :desc).first(10)

    if @secrets.empty?
      flash[:notice] = t('welcome')
      redirect_to new_secret_path
    end
  end
end
