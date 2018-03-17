class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.integer :rating, null: false
      t.string :votable_type
      t.bigint :votable_id
      t.bigint :user_id

      t.timestamps
    end

    add_index :votes, :votable_id
    add_index :votes, :votable_type
    add_index :votes, :user_id
  end
end
