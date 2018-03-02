# frozen_string_literal: true

require_relative 'acceptance_helper'

feature 'Delete files from question', %q{
 `In order to change my question as author of the question
  I'd like to be able to delete files
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:attachment) { create(:attachment, attachable: answer) }
  given(:second_user) { create(:user) }

  describe 'Invalid user deletes files from the answer' do
    scenario 'User deletes file from someone\'s answer on the question page', js: true do
      sign_in(second_user)
      visit question_path(question)

      within "#answer-id-#{answer.id}" do
        expect(page).not_to have_link 'Delete'
      end
    end

    scenario 'Anonymous user deletes file from someone\'s answer on the question page', js: true do
      visit question_path(question)

      within "#answer-id-#{answer.id}" do
        expect(page).not_to have_link 'Delete'
      end
    end
  end
end
