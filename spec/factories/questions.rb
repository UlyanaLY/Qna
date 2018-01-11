# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "Title #{n}" }
    body 'My Text'
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
