class HTMLToTextParser
  attr_accessor :doc

  def initialize(html)
    @doc = Nokogiri::HTML(html)
  end

  def run
    handle_br
    convert_to_text
  end

  def handle_br
    doc.css('br').each do |node|
      node.replace(Nokogiri::XML::Text.new("\n #{node.text}", doc))
    end
  end

  def convert_to_text
    @doc.text
  end
end
