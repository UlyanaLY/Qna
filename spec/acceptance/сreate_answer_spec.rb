# frozen_string_literal: true

require 'rails_helper'

feature 'Create answer', '
    In order to answer on a question
    As an authenticated user
    I want to be able to create an answer on questions
' do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user creates answer' do
    sign_in(user)

    visit question_path(question)
    fill_in 'answer_body', with: 'Text from answer'
    click_on 'Create'

    expect(page).to have_content 'Text from answer'
    expect(page).to have_content 'Answer was successfully created.'

    expect(current_path).to eq question_path(question)
  end

  scenario 'Non-authenticated user try to create answer' do
    visit question_path(question)
    click_on 'Create'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end