class CreateProjectIssues < ActiveRecord::Migration[8.0]
  def change
    create_table :project_issues, id: :uuid do |t|
      t.uuid "project_id"
      t.string "issue_encrypted_id", null: false
      t.timestamps

      t.index ["project_id"], name: "index_project_issues_on_project_id"
    end
  end
end
