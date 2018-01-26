# frozen_string_literal: true

require_relative 'acceptance_helper'

feature 'Accept answer as best', %q{
    In order to mark the best answer
    As an author of answer'\s question
    I want to be able to sign one question as best
} do

  given(:user) { create(:user) }
  given(:second_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }
  given!(:second_answer) { create(:answer, user: user, question: question) }

  scenario 'Unauthenticated user can\'t see link to accept the answer as best' do
    visit question_path(question)
    expect(page).to_not have_button 'Accept answer'
  end

  scenario 'Another authenticated user cannot sees link to mark the answer' do
    sign_in(second_user)
    visit question_path(question)
    expect(page).to_not have_button 'Accept answer'
  end

  describe 'Author of question' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'accept answer as best', js: true do
      within "#answer-id-#{answer.id}" do
        click_on 'Accept answer'
      end

      expect(page).to have_css '.best_answer'
      within '.best_answer' do
        expect(page).to_not have_button 'Accept answer'
      end
    end

    scenario ' choose new best answer', js: true do
      within "#answer-id-#{answer.id}" do
        click_on 'Accept answer'
      end
      within "#answer-id-#{second_answer.id}" do
        click_on 'Accept answer'
      end

      within '.best_answer' do
        expect(page).to have_content second_answer.body
      end
    end
  end
end
