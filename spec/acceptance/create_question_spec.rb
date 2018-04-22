# frozen_string_literal: true

require_relative 'acceptance_helper'

feature 'Create question', %q{
    In order to get answer from community
    As an authenticated user
    I want to be able to ask questions
} do

  given(:user) { create(:user) }
  context 'as authenticated user' do
    scenario 'Authenticated user creates question' do
      sign_in(user)
      visit questions_path

      click_on 'Ask question'
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Text for question'
      click_on 'Create'

      expect(page).to have_content 'Question was successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'Text for question'
    end

    scenario 'Authenticated user try creates a non-valid question' do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'

      fill_in 'Title', with: ''
      fill_in 'Body', with: ''
      click_on 'Create'

      expect(page).to have_content 'Title can\'t be blank'
      expect(page).to have_content 'Body can\'t be blank'
    end
  end

  context 'as non-authenticated user' do
    scenario 'Non-authenticated user try to create question' do
      visit questions_path

      expect(page).not_to have_content 'Ask question'
    end
  end

  context 'multiple sessions' do
    scenario 'question appears on another user\'s page' do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'Text for question'
        click_on 'Create'

        expect(page).to have_content 'Question was successfully created.'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'Text for question'
      end


      Capybara.using_session('guest') do
        visit questions_path
        expect(page).to have_content 'Test question'
      end
    end
  end
end
