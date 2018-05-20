# frozen_string_literal: true

require_relative 'acceptance_helper'

feature 'Add files to question answer', %q{
 `In order to illustrate my answer
  I'd like to be able to attach files
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  describe 'Author of answer adds files when he creates answer', js: true do
    background do
      sign_in(user)
      visit question_path(question)
      fill_in 'answer_body', with: 'Text from answer'
    end

    scenario 'User adds one file when asks question', js: true do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Create'
      visit current_path

      within '.answers' do
        expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      end
    end
    scenario 'User adds several files when asks question', js: true do
      within '#new_answer' do
        click_on 'add'
        inputs = all('input[type="file"]')
        inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
        inputs[1].set("#{Rails.root}/spec/rails_helper.rb")
        click_on 'Create'
        visit current_path
      end

      expect(page).to have_content 'spec_helper.rb'
      expect(page).to have_content 'rails_helper.rb'
    end
  end

  describe 'Author of answer adds files when he updates his answer', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'User adds one file when asks question', js: true do
      within '.answers' do
        click_on 'Edit'
        click_on 'add'
        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
        click_on 'Save'

        expect(page).to have_content 'spec_helper.rb'
      end
    end
    scenario 'User adds several files when asks question', js: true do
      within '.answers' do
        click_on 'Edit'
        click_on 'add'
        click_on 'add'
        inputs = all('input[type="file"]')
        inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
        inputs[1].set("#{Rails.root}/spec/rails_helper.rb")
        click_on 'Save'

        expect(page).to have_content 'spec_helper.rb'
        expect(page).to have_content 'rails_helper.rb'
      end
    end
  end
end
