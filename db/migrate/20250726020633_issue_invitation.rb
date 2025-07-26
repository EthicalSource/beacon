class IssueInvitation < ActiveRecord::Migration[8.0]
  def change
    create_table "issue_invitations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.string "issue_encrypted_id"
      t.string "email"
      t.timestamps
    end
  end
end
