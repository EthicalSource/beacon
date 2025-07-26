class CreateSurveys < ActiveRecord::Migration[8.0]
  def change
    create_table :surveys, id: :uuid do |t|
      t.uuid "project_id"
      t.string "issue_encrypted_id"
      t.string "account_encrypted_id"
      t.boolean "fairness"
      t.boolean "responsiveness"
      t.boolean "sensitivity"
      t.boolean "community"
      t.integer "would_recommend"
      t.text "recommendation_note"
      t.string "kind"
      t.timestamps

      t.index ["project_id"], name: "index_surveys_on_project_id"
    end
  end
end
