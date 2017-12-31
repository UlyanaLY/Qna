# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    title 'MyString'
    body 'Text for question'
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end

  factory :questions, class: Question do
    sequence(:title) { |n| "Title #{n}" }
    body 'My Text'
  end
end
