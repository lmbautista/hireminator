class CreateAuditLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :audit_logs do |t|
      t.references :target, polymorphic: true, null: false
      t.string :status, null: false
      t.jsonb :context, default: {}, null: false
      t.text :message
      t.string :initiator_id
      t.string :initiator_format

      t.timestamps
    end

    add_index :audit_logs, :status
    add_index :audit_logs, :initiator_id
    add_index :audit_logs, :initiator_format
    add_index :audit_logs, :context, using: :gin
  end
end
