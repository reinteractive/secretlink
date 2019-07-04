class PagesController < ApplicationController
  def home
    @user = User.new
  end

  def copyright
  end

  def privacy_policy
  end

  def terms_and_conditions
  end
end
