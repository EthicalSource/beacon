class CreateSuspiciousActivityLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :suspicious_activity_logs, id: :uuid do |t|
      t.string "controller"
      t.string "action"
      t.string "ip_address"
      t.text "params"
      t.uuid "account_id"
      t.timestamps

      t.index ["account_id"], name: "index_suspicious_activity_logs_on_account_id"

    end
  end
end
