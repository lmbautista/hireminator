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

ActiveRecord::Schema[7.1].define(version: 2025_04_08_163342) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "audit_logs", force: :cascade do |t|
    t.string "event", null: false
    t.string "status", null: false
    t.jsonb "context", default: {}, null: false
    t.text "message"
    t.string "initiator_id", null: false
    t.string "initiator_format", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["context"], name: "index_audit_logs_on_context", using: :gin
    t.index ["initiator_format"], name: "index_audit_logs_on_initiator_format"
    t.index ["initiator_id"], name: "index_audit_logs_on_initiator_id"
    t.index ["status"], name: "index_audit_logs_on_status"
  end

  create_table "conversations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "use_case_id"
    t.string "status", null: false
    t.json "input", default: {}
    t.json "output", default: {}
    t.datetime "ended_at"
    t.datetime "archived_at"
    t.text "full_transcript"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["use_case_id"], name: "index_conversations_on_use_case_id"
    t.index ["user_id"], name: "index_conversations_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.string "status", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id"
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "use_cases", force: :cascade do |t|
    t.string "name", null: false
    t.string "model", null: false
    t.float "temperature", null: false
    t.string "locale", null: false
    t.string "purpose", null: false
    t.string "provider", null: false
    t.json "initial_prompt", null: false
    t.json "resume_prompt"
    t.json "final_prompt"
    t.json "extraction_prompt"
    t.json "inputs", default: {}
    t.json "outputs", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_use_cases_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password", null: false
    t.string "role", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "conversations", "use_cases"
  add_foreign_key "conversations", "users"
  add_foreign_key "sessions", "users"
end
