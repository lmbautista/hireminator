class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.references :conversation, null: false, foreign_key: true
      t.string :status, null: false
      t.integer :sender_id, null: false
      t.string :sender_type, null: false
      t.string :role, null: false
      t.boolean :system_generated, default: false
      t.text :content, null: false

      t.timestamps
    end
  end
end
