# frozen_string_literal: true

require_relative 'acceptance_helper'

feature 'User can view a list of answers', %q{
  In order to find an answer
  As a user
  I want to be able to view list questions and answers
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 5, question: question, user: user) }

  scenario 'User can view answer to the question' do
    visit question_path(question)

    question.answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
