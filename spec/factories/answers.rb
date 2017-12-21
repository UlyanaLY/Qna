# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    body 'MyText'
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end
end
