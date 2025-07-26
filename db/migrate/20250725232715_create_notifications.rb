class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications, id: :uuid do |t|
      t.uuid "project_id"
      t.uuid "issue_id"
      t.uuid "issue_comment_id"
      t.timestamps

      t.index ["issue_comment_id"], name: "index_notifications_on_issue_comment_id"
      t.index ["issue_id"], name: "index_notifications_on_issue_id"
      t.index ["project_id"], name: "index_notifications_on_project_id"
    end
  end
end
