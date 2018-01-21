# frozen_string_literal: true

require 'rails_helper'

feature 'Create answer', %q{
    In order to answer on a question
    As an authenticated user
    I want to be able to create an answer on questions
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user creates answer', js: true do
    sign_in(user)

    visit question_path(question)
    fill_in 'answer_body', with: 'Text from answer'
    click_on 'Create'

    within'.answers' do
      expect(page).to have_content 'Text from answer'
    end
    expect(current_path).to eq question_path(question)
  end

  scenario 'Non-authenticated user try to create answer' do
    visit question_path(question)
    click_on 'Create'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Authenticated user try creates a non-valid answer' do
    sign_in(user)

    visit question_path(question)
    fill_in 'Body', with: ''
    click_on 'Create'

    expect(page).to have_content 'Body can\'t be blank'
  end
end
