# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_07_26_020633) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"
  enable_extension "uuid-ossp"

  create_table "abuse_report_subjects", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "abuse_report_id"
    t.uuid "account_id"
    t.uuid "project_id"
    t.uuid "issue_id"
    t.index ["abuse_report_id"], name: "index_abuse_report_subjects_on_abuse_report_id"
    t.index ["account_id"], name: "index_abuse_report_subjects_on_account_id"
    t.index ["issue_id"], name: "index_abuse_report_subjects_on_issue_id"
    t.index ["project_id"], name: "index_abuse_report_subjects_on_project_id"
  end

  create_table "abuse_reports", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id"
    t.text "description"
    t.string "aasm_state"
    t.integer "report_number"
    t.text "admin_note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_abuse_reports_on_account_id"
  end

  create_table "account_activity_logs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id"
    t.integer "issues_opened", default: 0
    t.integer "issues_dismissed", default: 0
    t.integer "issues_marked_spam", default: 0
    t.integer "times_blocked", default: 0
    t.integer "times_flagged", default: 0
    t.integer "projects_created", default: 0
    t.integer "password_resets", default: 0
    t.integer "recaptcha_failures", default: 0
    t.integer "four_o_fours", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "account_issues", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id"
    t.string "issue_encrypted_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "account_project_blocks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "project_id"
    t.uuid "account_id"
    t.text "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_account_project_blocks_on_account_id"
    t.index ["project_id"], name: "index_account_project_blocks_on_project_id"
  end

  create_table "accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "temp_2fa_code"
    t.boolean "email_confirmed"
    t.string "normalized_email"
    t.string "hashed_email"
    t.string "notification_encrypted_ids", default: [], array: true
    t.boolean "is_admin", default: false
    t.boolean "is_flagged", default: false
    t.text "flagged_reason"
    t.datetime "flagged_at", precision: nil
    t.boolean "flag_requested", default: false
    t.text "flag_requested_reason"
    t.string "phone_encrypted"
    t.string "authy_id"
    t.datetime "last_sign_in_with_authy", precision: nil
    t.boolean "authy_enabled", default: false
    t.boolean "send_sms_on_issue_open", default: false
    t.boolean "is_external_reporter", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.index ["authy_id"], name: "index_accounts_on_authy_id"
    t.index ["confirmation_token"], name: "index_accounts_on_confirmation_token", unique: true
    t.index ["email"], name: "index_accounts_on_email", unique: true
    t.index ["normalized_email"], name: "index_accounts_on_normalized_email", unique: true
    t.index ["reset_password_token"], name: "index_accounts_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_accounts_on_unlock_token", unique: true
  end

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "autoresponders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "project_id"
    t.uuid "organization_id"
    t.string "scope"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_autoresponders_on_organization_id"
    t.index ["project_id"], name: "index_autoresponders_on_project_id"
  end

  create_table "consequence_guides", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "organization_id"
    t.uuid "project_id"
    t.string "scope"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_consequence_guides_on_organization_id"
    t.index ["project_id"], name: "index_consequence_guides_on_project_id"
  end

  create_table "consequences", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "severity"
    t.uuid "consequence_guide_id"
    t.string "label"
    t.text "action"
    t.text "consequence"
    t.string "email_to_notify"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["consequence_guide_id"], name: "index_consequences_on_consequence_guide_id"
  end

  create_table "contact_messages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "message"
    t.text "sender_ip"
    t.string "sender_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "credentials", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.string "email"
    t.uuid "account_id"
    t.string "token_encrypted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_credentials_on_account_id"
    t.index ["provider", "uid"], name: "index_credentials_on_provider_and_uid", unique: true
  end

  create_table "invitations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id"
    t.uuid "project_id"
    t.uuid "organization_id"
    t.string "email"
    t.boolean "is_owner", default: false
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_invitations_on_account_id"
    t.index ["organization_id"], name: "index_invitations_on_organization_id"
    t.index ["project_id"], name: "index_invitations_on_project_id"
  end

  create_table "issue_comments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "text"
    t.string "comment"
    t.string "commenter_encrypted_id"
    t.boolean "visible_to_reporter", default: false
    t.uuid "issue_id"
    t.boolean "visible_to_respondent", default: false
    t.boolean "visible_only_to_moderators", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "issue_events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "event"
    t.string "actor_encrypted_id"
    t.uuid "issue_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_id"], name: "index_issue_events_on_issue_id"
  end

  create_table "issue_invitations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "issue_encrypted_id"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "issues", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "description"
    t.string "reporter_encrypted_id"
    t.integer "issue_number"
    t.string "project_encrypted_id"
    t.string "aasm_state"
    t.text "urls", default: [], array: true
    t.boolean "is_spam", default: false
    t.boolean "is_abusive", default: false
    t.datetime "acknowledged_at", precision: nil
    t.datetime "closed_at", precision: nil
    t.text "respondent_summary"
    t.text "respondent_encrypted_id"
    t.text "resolution_text"
    t.datetime "resolved_at", precision: nil
    t.uuid "consequence_id"
    t.uuid "reporter_consequence_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "moderator_blocks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "issue_id"
    t.uuid "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_moderator_blocks_on_account_id"
    t.index ["issue_id"], name: "index_moderator_blocks_on_issue_id"
  end

  create_table "notifications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "project_id"
    t.uuid "issue_id"
    t.uuid "issue_comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_comment_id"], name: "index_notifications_on_issue_comment_id"
    t.index ["issue_id"], name: "index_notifications_on_issue_id"
    t.index ["project_id"], name: "index_notifications_on_project_id"
  end

  create_table "organizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_organizations_on_account_id"
  end

  create_table "project_issues", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "project_id"
    t.string "issue_encrypted_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_issues_on_project_id"
  end

  create_table "project_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "paused_at", precision: nil
    t.integer "rate_per_day", default: 5
    t.boolean "require_3rd_party_auth", default: false
    t.integer "minimum_3rd_party_auth_age_in_days", default: 30
    t.boolean "allow_anonymous_issues", default: false
    t.boolean "publish_stats", default: true
    t.uuid "project_id"
    t.boolean "show_moderator_names", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_settings_on_project_id"
  end

  create_table "projects", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_projects_on_account_id"
    t.index ["name"], name: "index_projects_on_name"
    t.index ["organization_id"], name: "index_projects_on_organization_id"
    t.index ["organization_name"], name: "index_projects_on_organization_name"
    t.index ["slug"], name: "index_projects_on_slug", unique: true
    t.index ["sort_key"], name: "index_projects_on_sort_key"
  end

  create_table "respondent_templates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "project_id"
    t.text "text"
    t.boolean "is_beacon_default", default: false
    t.uuid "organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_respondent_templates_on_organization_id"
    t.index ["project_id"], name: "index_respondent_templates_on_project_id"
  end

  create_table "roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id"
    t.uuid "organization_id"
    t.uuid "project_id"
    t.boolean "is_owner", default: false
    t.boolean "is_default_moderator", default: false
    t.boolean "can_manage_org", default: false
    t.boolean "can_create_org_projects", default: false
    t.boolean "can_see_historic_issues", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_roles_on_account_id"
    t.index ["organization_id"], name: "index_roles_on_organization_id"
    t.index ["project_id"], name: "index_roles_on_project_id"
  end

  create_table "surveys", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_surveys_on_project_id"
  end

  create_table "suspicious_activity_logs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "controller"
    t.string "action"
    t.string "ip_address"
    t.text "params"
    t.uuid "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_suspicious_activity_logs_on_account_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
