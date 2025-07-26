class CreateIssueComments < ActiveRecord::Migration[8.0]
  def change
    create_table :issue_comments, id: :uuid do |t|
      t.text :text
      t.string :comment
      t.string "commenter_encrypted_id"
      t.boolean "visible_to_reporter", default: false
      t.uuid "issue_id"
      t.boolean "visible_to_respondent", default: false
      t.boolean "visible_only_to_moderators", default: false
      t.timestamps
    end
  end
end
