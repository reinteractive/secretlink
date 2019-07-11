require "rails_helper"

describe HTMLToTextParser do
  let!(:html) { "<div>First line.<br>Second line.</div>" }
  let!(:parser) { HTMLToTextParser.new html }

  it "converts html to text" do
    expect(parser.run).to eq "First line.\n Second line."
  end
end
