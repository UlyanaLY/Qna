# frozen_string_literal: true

require_relative 'acceptance_helper'

feature 'Delete files from question', %q{
 `In order to change my question as author of the question
  I'd like to be able to delete files
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:attachment) { create(:attachment, attachable: question) }
  given(:second_user) { create(:user) }

  describe 'Author of question deletes files from his question' do
    before do
      sign_in(user)
      visit questions_path
    end

    scenario 'User deletes file when he sees his question', js: true do
      within "#question-id-#{question.id}" do
        click_on question.title
      end

      expect(page).to have_link 'Удалить'
      click_on 'Удалить'
      expect(page).not_to have_selector "#question_attachment-id-#{question.id}"
    end

    scenario 'User deletes  file when he edits his question', js: true do
      within "#question-id-#{question.id}" do
        click_on 'Edit'
      end

      expect(page).to have_link 'Удалить'
      click_on 'Удалить'
      expect(page).not_to have_selector "#question_attachment-id-#{question.id}"
    end
  end

  describe 'Invalid user' do
    scenario 'Anonymous user can\'t see link to delete file from answer' do
      sign_in(second_user)
      visit questions_path

      within "#question-id-#{question.id}" do
        expect(page).to_not have_content 'Delete'
      end
    end

    scenario 'Non-author can\'t add files for foreign question' do
      visit questions_path

      within "#question-id-#{question.id}" do
        expect(page).to_not have_content 'Delete'
      end
    end
  end
end
