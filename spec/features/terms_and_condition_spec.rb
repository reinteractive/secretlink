require 'rails_helper'

describe 'Terms and Conditions', type: :feature do
  it 'loads terms and condition page' do
    visit terms_and_conditions_path

    expect(page).to have_content('Terms & Conditions for Envisage')
  end
end
