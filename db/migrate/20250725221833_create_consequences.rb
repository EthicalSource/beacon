class CreateConsequences < ActiveRecord::Migration[8.0]
  def change
    create_table :consequences, id: :uuid do |t|
      t.integer :severity
			t.uuid :consequence_guide_id
      t.string :label
      t.text :action
      t.text :consequence
      t.string :email_to_notify
      t.timestamps
      t.index ["consequence_guide_id"], name: "index_consequences_on_consequence_guide_id"
    end
  end
end
