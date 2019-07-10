class EmailTemplateController < AuthenticatedController
  layout 'settings'

  def edit
    @settings = current_user.settings

    unless @settings.send_secret_email_template
      override = ERB.new(load_template).result(view_context.__binding__)
      @settings.send_secret_email_template = override
    end
  end

  def update
  end

  def load_template
    path = Rails.root.join('app/views/secret_mailer/secret_notification_editable.html.erb')
    File.read(path)
  end
end
