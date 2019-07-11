require "rails_helper"

class SampleContext
  attr_accessor :user
  def initialize
    @user = User.new(email: 'user@test.com' )
  end
end

describe ViewBuilder do
  let!(:template) { 'sample_template.html.erb' }
  let!(:context) { SampleContext.new }

  before { ViewBuilder::DEFAULT_DIR = 'spec/support' }
  after { ViewBuilder::DEFAULT_DIR = 'app/views' }

  it "converts html to text" do
    view = ViewBuilder.new(template, context.__binding__).run
    expect(view).to match(/This is a sample template/)
    expect(view).to match(/This depends on a user user@test.com/)
  end
end
