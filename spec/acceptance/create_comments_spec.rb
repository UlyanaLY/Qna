require_relative 'acceptance_helper'

feature 'Create comment',  %q{
    In order to express my opinion
    As an authenticated user
    I want to be able to create comments for answer and/or question'
 } do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'An authenticated user tries to create comment for a question', js: true do
    sign_in(user)
    visit question_path(question)

    within '.question-container' do

      fill_in 'comment_body', with: 'Text from comment(question)'
      click_on 'Place a comment'
      expect(page).to have_content 'Text from comment'
    end
  end

  scenario 'An authenticated user tries to create comment for an answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      fill_in 'comment_body', with: 'Text from comment(answer)'
      click_on 'Place a comment'
      expect(page).to have_content 'Text from comment(answer)'
    end
  end

  context 'multiple sessions' do
    scenario "comments for question appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.question-container' do
          fill_in 'comment_body', with: 'Text from comment(question)'
          click_on 'Place a comment'
          expect(page).to have_content 'Text from comment'
        end
      end

      Capybara.using_session('guest') do
        within '.question-container' do
          expect(page).to have_content 'Text from comment'
        end
      end
    end

    scenario "comments for answer appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.answers' do
          fill_in 'comment_body', with: 'Text from comment(answer)'
          click_on 'Place a comment'
          expect(page).to have_content 'Text from comment(answer)'
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content 'Text from comment(answer)'
        end
      end
    end
  end
end