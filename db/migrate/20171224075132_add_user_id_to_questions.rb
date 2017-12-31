# frozen_string_literal: true

class AddUserIdToQuestions < ActiveRecord::Migration[5.1]
  def change
    add_belongs_to :questions, :user, foreign_key: :user
  end
end
