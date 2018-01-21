# frozen_string_literal: true

require_relative 'acceptance_helper'

feature 'User can view a list of questions', %q{
  In order to find an answer or a question
  As a user
  I want to be able to view list questions and answers
} do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 5, user: user) }

  scenario 'User can view a list of questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end
