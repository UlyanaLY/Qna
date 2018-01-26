# frozen_string_literal: true

class AdBestAnswerToUser < ActiveRecord::Migration[5.1]
  change_table :answers do |t|
    t.boolean 'best', default: false, null: false
  end
end
