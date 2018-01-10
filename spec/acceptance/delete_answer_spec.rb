# frozen_string_literal: true

require 'rails_helper'

feature 'Delete answer', %q{
    In order to delete useless answer
    I want to be able to delete my own answer
} do

  given(:user) { create(:user) }
  given(:second_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  scenario 'Authenticated user delete his answer' do
    sign_in(user)
    question
    answer

    visit question_path(question)
    click_on 'Удалить'

    expect(page).to_not have_content answer.body
    expect(current_path).to eq question_path(question)
  end

  scenario 'Another user cannot delete the answer of other user' do
    sign_in(second_user)
    question
    answer

    visit question_path(question)

    expect(page).to_not have_content 'Удалить'
  end

  scenario 'Non-authenticated user try to delete answer' do
    question
    answer
    visit question_path(question)

    expect(page).to_not have_content 'Удалить'
  end
end
