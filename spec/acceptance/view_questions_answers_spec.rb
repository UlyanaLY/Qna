# frozen_string_literal: true

require 'rails_helper'

feature 'User can view a list of questions and answers', %q{
  In order to find an answer or a question
  As a user
  I want to be able to view list questions and answers
} do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 5, user: user) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 5, question: question, user: user) }

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