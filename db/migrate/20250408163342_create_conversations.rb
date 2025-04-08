class CreateConversations < ActiveRecord::Migration[7.1]
  def change
    create_table :conversations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :use_case, foreign_key: true
      t.string :status, null: false
      t.json :input, default: {}
      t.json :output, default: {}
      t.datetime :ended_at
      t.datetime :archived_at
      t.text :full_transcript

      t.timestamps
    end
  end
end
