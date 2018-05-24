# frozen_string_literal: true

FactoryBot.define do
  factory :attachment do
    file File.open(File.join(Rails.root, 'public/robots.txt'))

    factory :attachment_api do
      # file "MyString"
      file { File.new("#{Rails.root}/spec/spec_helper.rb") }
      attachable nil
    end
  end
end
