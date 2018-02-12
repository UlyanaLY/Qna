# frozen_string_literal: true

require_relative 'acceptance_helper'

feature 'Add files to question', %q{
 `In order to illustrate my question as author of the question
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:second_user) { create(:user) }

  describe 'Author of question adds files when he asks question' do
    background do
      sign_in(user)
      visit new_question_path
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Text for question'
    end

    scenario 'User adds one file when asks question', js: true do
      click_on 'add attachment'

      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Create'

      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end

    scenario 'User adds several files when he asks question', js: true do
      click_on 'add attachment'
      click_on 'add attachment'
      inputs = all('input[type="file"]')
      inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
      inputs[1].set("#{Rails.root}/spec/rails_helper.rb")
      click_on 'Create'

      expect(page).to have_content 'spec_helper.rb'
      expect(page).to have_content 'rails_helper.rb'
    end
  end

  describe 'Author of question adds files when he edits his question' do
    before do
      sign_in(user)
      visit questions_path
    end

    scenario 'User adds one file when he asks question', js: true do
      within "#question-id-#{question.id}" do
        click_on 'Edit'
      end

      within '.edit_question' do
        click_on 'add attachment'
        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
        click_on 'Save'
      end

      expect(page).to have_content 'spec_helper.rb'
    end

    scenario 'User adds several files when he asks question', js: true do
      within "#question-id-#{question.id}" do
        click_on 'Edit'
      end

      within '.edit_question' do
        click_on 'add attachment'
        click_on 'add attachment'
        inputs = all('input[type="file"]')
        inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
        inputs[1].set("#{Rails.root}/spec/rails_helper.rb")
        click_on 'Save'
      end

      expect(page).to have_content 'spec_helper.rb'
      expect(page).to have_content 'rails_helper.rb'
    end
  end

  describe 'Invalid user' do
    scenario 'can\'t add files for foreign question' do
      sign_in(second_user)
      visit questions_path

      within "#question-id-#{question.id}" do
        expect(page).to_not have_content 'Edit'
      end
    end

    scenario 'can\'t add files for foreign question' do
      visit questions_path

      within "#question-id-#{question.id}" do
        expect(page).to_not have_content 'Edit'
      end
    end
  end
end
