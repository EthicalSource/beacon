class IssueEvent < ActiveRecord::Migration[8.0]
  def change
    create_table "issue_events", id: :uuid do |t|
      t.string "event"
      t.string "actor_encrypted_id"
      t.uuid "issue_id"
      t.timestamps
      t.index ["issue_id"], name: "index_issue_events_on_issue_id"
    end
  end
end
