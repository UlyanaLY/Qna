# frozen_string_literal: true

class AddUserIdToAnswers < ActiveRecord::Migration[5.1]
  def change
    add_belongs_to :answers, :user, foreign_key: :user
  end
end
