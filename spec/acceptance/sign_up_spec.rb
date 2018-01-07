# frozen_string_literal: true

require 'rails_helper'

feature 'User sign up', '
  In oder be able to create questions and answers,
  as an user
  I want to be able to sign up
' do

  scenario 'Registration with valid attributes' do
    visit new_user_registration_path

    sign_up

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(page).to have_link 'Logout'
  end
end
