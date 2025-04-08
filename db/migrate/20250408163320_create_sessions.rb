class CreateSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :sessions do |t|
      t.string :session_id, null: false
      t.string :status, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :sessions, :session_id
  end
end
