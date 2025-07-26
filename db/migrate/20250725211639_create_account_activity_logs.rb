class CreateAccountActivityLogs < ActiveRecord::Migration[8.0]
  def change
    enable_extension 'pgcrypto'
    enable_extension "uuid-ossp"
    create_table :account_activity_logs, id: :uuid, default: 'gen_random_uuid()' do |t|
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
      t.timestamps
    end
  end
end
