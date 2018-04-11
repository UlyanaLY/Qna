class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.text :body
      t.string :commentable_type
      t.bigint :commentable_id
      t.references :user, foreign_key: { on_delete: :cascade }

      t.timestamps
    end

    add_index :comments, %i[commentable_id commentable_type]
    add_index :comments, %i[commentable_id commentable_type user_id], name: 'commentable_type_us_id_com_id'
  end
end
