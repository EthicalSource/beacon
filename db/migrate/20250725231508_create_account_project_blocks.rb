class CreateAccountProjectBlocks < ActiveRecord::Migration[8.0]
  def change
    create_table :account_project_blocks, id: :uuid do |t|
      t.uuid "project_id"
      t.uuid "account_id"
      t.text "reason"
      t.timestamps
      t.index ["account_id"], name: "index_account_project_blocks_on_account_id"
      t.index ["project_id"], name: "index_account_project_blocks_on_project_id"
    end
  end
end
