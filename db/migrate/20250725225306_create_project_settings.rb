class CreateProjectSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :project_settings, id: :uuid do |t|
      t.datetime "paused_at", precision: nil
      t.integer "rate_per_day", default: 5
      t.boolean "require_3rd_party_auth", default: false
      t.integer "minimum_3rd_party_auth_age_in_days", default: 30
      t.boolean "allow_anonymous_issues", default: false
      t.boolean "publish_stats", default: true
      t.uuid "project_id"
      t.boolean "show_moderator_names", default: false
      t.timestamps

      t.index ["project_id"], name: "index_project_settings_on_project_id"
    end
  end
end
