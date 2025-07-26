class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects, id: :uuid do |t|
      t.string "name", null: false
      t.string "slug", null: false
      t.string "url", null: false
      t.string "coc_url", null: false
      t.text "description", null: false
      t.uuid "account_id"
      t.boolean "has_confirmed_settings", default: false
      t.datetime "confirmed_at", precision: nil
      t.boolean "is_flagged", default: false
      t.text "flagged_reason"
      t.datetime "flagged_at", precision: nil
      t.boolean "public", default: false
      t.boolean "setup_complete", default: false
      t.uuid "organization_id"
      t.string "confirmation_token_url"
      t.string "repo_url"
      t.boolean "is_event", default: false
      t.integer "duration"
      t.string "frequency"
      t.string "attendees"
      t.string "sort_key", default: ""
      t.string "organization_name"
      t.boolean "accept_issues_by_email", default: false
      t.boolean "bulk_created", default: false
      t.timestamps

      t.index ["account_id"], name: "index_projects_on_account_id"
      t.index ["name"], name: "index_projects_on_name"
      t.index ["organization_id"], name: "index_projects_on_organization_id"
      t.index ["organization_name"], name: "index_projects_on_organization_name"
      t.index ["slug"], name: "index_projects_on_slug", unique: true
      t.index ["sort_key"], name: "index_projects_on_sort_key"
    end
  end
end
