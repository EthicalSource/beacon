class CreateModeratorBlocks < ActiveRecord::Migration[8.0]
  def change
    create_table :moderator_blocks, id: :uuid do |t|
      t.uuid "issue_id"
      t.uuid "account_id"
      t.timestamps
      t.index ["account_id"], name: "index_moderator_blocks_on_account_id"
      t.index ["issue_id"], name: "index_moderator_blocks_on_issue_id"
    end
  end
end
