class CreateCredentials < ActiveRecord::Migration[8.0]
  def change
    create_table :credentials, id: :uuid do |t|
      t.string "provider"
      t.string "uid"
      t.string "email"
      t.uuid "account_id"
      t.string "token_encrypted"
      t.timestamps
      t.index ["account_id"], name: "index_credentials_on_account_id"
      t.index ["provider", "uid"], name: "index_credentials_on_provider_and_uid", unique: true
    end
  end
end
