# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "Body #{n}" }
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end
end
