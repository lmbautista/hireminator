# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_04_07_220458) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "audit_logs", force: :cascade do |t|
    t.string "target_type", null: false
    t.bigint "target_id", null: false
    t.string "status", null: false
    t.jsonb "context", default: {}, null: false
    t.text "message"
    t.string "initiator_id"
    t.string "initiator_format"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["context"], name: "index_audit_logs_on_context", using: :gin
    t.index ["initiator_format"], name: "index_audit_logs_on_initiator_format"
    t.index ["initiator_id"], name: "index_audit_logs_on_initiator_id"
    t.index ["status"], name: "index_audit_logs_on_status"
    t.index ["target_type", "target_id"], name: "index_audit_logs_on_target"
  end

end
