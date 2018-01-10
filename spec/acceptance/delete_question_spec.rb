# frozen_string_literal: true

require 'rails_helper'

feature 'Delete question', %q{
   In order to delete useless question
   I want to be able to delete my own question
} do

  given(:user) { create(:user) }
  given(:second_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user can delete  his question' do
    sign_in(user)
    question

    visit questions_path
    click_on 'Удалить'

    expect(page).to have_content 'Question was successfully destroyed.'
    expect(page).not_to have_content 'Test question'
    expect(page).not_to have_content 'Text for question'
  end

  scenario 'Authenticated user cannot delete the question of other user' do
    sign_in(second_user)
    question

    visit questions_path
    expect(page).to_not have_content 'Удалить'
  end

  scenario 'Non-authenticated user try to delete question' do
    visit questions_path
    question

    expect(page).to_not have_content 'Удалить'
  end
end
