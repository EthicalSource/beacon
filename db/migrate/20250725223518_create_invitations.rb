class CreateInvitations < ActiveRecord::Migration[8.0]
  def change
    create_table :invitations, id: :uuid do |t|
      t.uuid "account_id"
      t.uuid "project_id"
      t.uuid "organization_id"
      t.string "email"
      t.boolean "is_owner", default: false
      t.text "message"
      t.timestamps

      t.index ["account_id"], name: "index_invitations_on_account_id"
      t.index ["organization_id"], name: "index_invitations_on_organization_id"
      t.index ["project_id"], name: "index_invitations_on_project_id"
    end
  end
end
