# frozen_string_literal: true

require_relative 'acceptance_helper'

feature 'Delete answer', %q{
    In order to delete useless answer
    I want to be able to delete my own answer
} do

  given(:user) { create(:user) }
  given(:second_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  scenario 'Authenticated user delete his answer', js: true do
    sign_in(user)

    visit question_path(question)
    click_on 'Delete'

    expect(page).to_not have_content answer.body
    expect(page).to have_content 'Answer was successfully destroyed.'
  end

  scenario 'Another user cannot delete the answer of other user' do
    sign_in(second_user)

    visit question_path(question)

    expect(page).to_not have_content 'Delete'
  end

  #scenario 'Non-authenticated user try to delete answer' do
  #  visit question_path(question)

  #  expect(page).to_not have_content 'Delete'
  #end
end
