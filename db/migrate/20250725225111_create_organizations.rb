class CreateOrganizations < ActiveRecord::Migration[8.0]
  def change
    create_table :organizations, id: :uuid do |t|
      t.string "name"
      t.string "url"
      t.string "coc_url"
      t.string "slug"
      t.text "description"
      t.uuid "account_id"
      t.string "remote_org_name"
      t.boolean "is_flagged", default: false
      t.text "flagged_reason"
      t.boolean "accept_issues_by_email", default: false
      t.timestamps

      t.index ["account_id"], name: "index_organizations_on_account_id"
    end
  end
end
