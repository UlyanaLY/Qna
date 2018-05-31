# frozen_string_literal: true

require_relative 'acceptance_helper'

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

    within '.answers' do
      expect(page).to have_content 'Text from answer'
    end
    expect(current_path).to eq question_path(question)
  end

  scenario 'Non-authenticated user try to create answer' do
    visit question_path(question)
    click_on 'Create'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  #scenario 'User try to create invalid answer', js: true do
  #  sign_in(user)

  # visit question_path(question)
  #  click_on 'Create'
  #  expect(page).to have_content 'Body can\'t be blank'
  #end

  context 'multiple sessions' , js: true do
    scenario 'answer appears on another user\'s page' do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'answer_body', with: 'Text from answer'
        click_on 'Create'

        within '.answers' do
          expect(page).to have_content 'Text from answer'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Text from answer'
      end
    end
  end
end
