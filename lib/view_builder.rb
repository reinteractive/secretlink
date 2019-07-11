class ViewBuilder
  DEFAULT_DIR = 'app/views'

  attr_accessor :view_path, :view_binding

  def initialize(view_path, view_binding)
    @view_path = view_path
    @view_binding = view_binding
  end

  def run
    parse_template(load_template)
  end

  private

  def parse_template(template)
    ERB.new(template).result(view_binding)
  end

  def load_template
    path = Rails.root.join(DEFAULT_DIR, view_path)
    File.read(path)
  end
end
