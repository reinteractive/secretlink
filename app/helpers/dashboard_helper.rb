module DashboardHelper
  def dashboard_time_display(time)
    time.in_time_zone.strftime("%m/%d/%y, %l.%M%P")
  end

  def viewed_status(secret)
    if secret.consumed_at?
      "Viewed: #{dashboard_time_display(secret.consumed_at)}"
    else
      "not viewed, expiry: #{dashboard_time_display(secret.expire_at)}"
    end
  end
end
