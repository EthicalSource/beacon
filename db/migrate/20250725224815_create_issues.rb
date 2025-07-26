class CreateIssues < ActiveRecord::Migration[8.0]
  def change
    create_table :issues, id: :uuid do |t|
      t.text "description"
      t.string "reporter_encrypted_id"
      t.integer "issue_number"
      t.string "project_encrypted_id"
      t.string "aasm_state"
      t.text "urls", default: [], array: true
      t.boolean "is_spam", default: false
      t.boolean "is_abusive", default: false
      t.datetime "acknowledged_at", precision: nil
      t.datetime "closed_at", precision: nil
      t.text "respondent_summary"
      t.text "respondent_encrypted_id"
      t.text "resolution_text"
      t.datetime "resolved_at", precision: nil
      t.uuid "consequence_id"
      t.uuid "reporter_consequence_id"
      t.timestamps
    end
  end
end
