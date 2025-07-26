class CreateAbuseReportSubjects < ActiveRecord::Migration[8.0]
  def change
    create_table :abuse_report_subjects, id: :uuid do |t|
      t.uuid "abuse_report_id"
      t.uuid "account_id"
      t.uuid "project_id"
      t.uuid "issue_id"
      t.index ["abuse_report_id"], name: "index_abuse_report_subjects_on_abuse_report_id"
      t.index ["account_id"], name: "index_abuse_report_subjects_on_account_id"
      t.index ["issue_id"], name: "index_abuse_report_subjects_on_issue_id"
      t.index ["project_id"], name: "index_abuse_report_subjects_on_project_id"
    end
  end
end
