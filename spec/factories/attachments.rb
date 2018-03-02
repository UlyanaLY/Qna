# frozen_string_literal: true

FactoryBot.define do
  factory :attachment do
    file File.open(File.join(Rails.root, 'public/robots.txt'))
  end
end
