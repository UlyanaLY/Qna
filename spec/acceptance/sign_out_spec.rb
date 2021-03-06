# frozen_string_literal: true

require_relative 'acceptance_helper'

feature 'User sign out', %q{
  In oder to quit site,
  as an user
  I want to be able to sign out
} do

  given(:user) { create(:user) }

  scenario 'Registered user try to sign out' do
    sign_in(user)
    click_on 'Logout'

    expect(page).to have_content 'Signed out successfully.'
  end
end
