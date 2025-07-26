class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
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
      t.timestamps
      t.index ["authy_id"], name: "index_accounts_on_authy_id"
      t.index ["confirmation_token"], name: "index_accounts_on_confirmation_token", unique: true
      t.index ["email"], name: "index_accounts_on_email", unique: true
      t.index ["normalized_email"], name: "index_accounts_on_normalized_email", unique: true
      t.index ["reset_password_token"], name: "index_accounts_on_reset_password_token", unique: true
      t.index ["unlock_token"], name: "index_accounts_on_unlock_token", unique: true
    end
  end
end
