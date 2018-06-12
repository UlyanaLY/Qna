require_relative 'acceptance_helper'

feature 'Search', %q{
  In order to find information
  As user
  I want to search info about questions, answers, comments
  and users
} do
  given!(:user) { create(:user, email: "search@mail.ru") }
  given!(:question) { create(:question, user: user, title: "question for search") }
  given!(:answer) { create(:answer, question: question, user: user, body: "answer for search") }
  given!(:comment_for_question) { create(:comment, commentable: question, user: user, body: "question comment for search") }
  given!(:comment_for_answer) { create(:comment, commentable: answer,  user: user, body: "answer comment for search") }


  context 'Users' do
    scenario 'can view search field with attributes' do
      visit root_path

      %w(Everywhere Questions Answers Comments Users).each do |attr|
        expect(page).to have_content attr
      end
    end

    scenario 'can search and view result page' do
      ThinkingSphinx::Test.run do
        ThinkingSphinx::Test.index
          visit root_path
          fill_in 'query', with: 'Something not from our site'
          click_on 'Search'

          expect(page).to have_content "No results"
      end
    end

    scenario 'can search in category Questions' , js: true do
      ThinkingSphinx::Test.run do
        ThinkingSphinx::Test.index
        visit root_path
          fill_in 'query', with: 'question for search'
          select 'Questions', from: 'category'
          click_on 'Search'

          within '.results' do
            expect(page).to have_content question.title
            expect(page).to_not have_content answer.body
            expect(page).to_not have_content user.email
          end
        end
    end

    scenario 'can search in category Answers', js: true do
      ThinkingSphinx::Test.run do
        ThinkingSphinx::Test.index
          visit root_path
          fill_in 'query', with: 'search'
          select 'Answers', from: 'category'
          click_on 'Search'

        within '.results' do
          expect(page).to_not have_content question.title
          expect(page).to have_content answer.body
          expect(page).to_not have_content user.email
        end
      end
    end

    scenario 'can search answer comments in category Comments', js: true do
      ThinkingSphinx::Test.run do
        ThinkingSphinx::Test.index
        visit root_path
        fill_in 'query', with: 'answer comment for search'
        select 'Comments', from: 'category'
        click_on 'Search'

        within '.results' do
          expect(page).to_not have_content question.title
          expect(page).to_not have_content answer.body
          expect(page).to have_content comment_for_answer.body
          expect(page).to_not have_content user.email
        end
      end
    end

    scenario 'can search question comments in category Comments', js: true do
      ThinkingSphinx::Test.run do
        ThinkingSphinx::Test.index
        visit root_path
        fill_in 'query', with: 'question comment for search'
        select 'Comments', from: 'category'
        click_on 'Search'

        within '.results' do
          expect(page).to_not have_content question.title
          expect(page).to_not have_content answer.body
          expect(page).to have_content comment_for_question.body
          expect(page).to_not have_content user.email
        end
      end
    end
  end
end