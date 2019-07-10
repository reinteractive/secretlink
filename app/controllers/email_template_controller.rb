class EmailTemplateController < AuthenticatedController
  layout 'settings'

  def edit
    @settings = current_user.settings
  end

  def update
  end
end
