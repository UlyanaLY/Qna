# frozen_string_literal: true

require 'rails_helper'

feature 'User can view a list of questions and answers', '
  In order to find an answer
  As a user
  I want to be able to view list questions and answers
' do
  given!(:questions) { create_list(:questions, 5) }
  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 5, question: question) }

  scenario 'User can view a list of questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end

  scenario 'User can view answer to the question' do
    visit question_path(question)

    question.answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
