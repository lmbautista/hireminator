class CreateUseCases < ActiveRecord::Migration[7.1]
  def change
    create_table :use_cases do |t|
      t.string :name, null: false
      t.string :model, null: false
      t.float :temperature, null: false
      t.string :locale, null: false
      t.string :purpose, null: false
      t.string :provider, null: false
      t.json :initial_prompt, null: false
      t.json :resume_prompt
      t.json :final_prompt
      t.json :extraction_prompt
      t.json :inputs, default: {}
      t.json :outputs, default: {}

      t.timestamps
    end

    add_index :use_cases, :name, unique: true
  end
end