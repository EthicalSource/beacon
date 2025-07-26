 class CreateAbuseReports < ActiveRecord::Migration[8.0]

  def change
    create_table :abuse_reports, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.uuid "account_id"
      t.text "description"
      t.string "aasm_state"
      t.integer "report_number"
      t.text "admin_note"
      t.timestamps
      t.index ["account_id"], name: "index_abuse_reports_on_account_id"
    end
  end
end
