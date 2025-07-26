class CreateAutoresponders < ActiveRecord::Migration[8.0]
  def change
    create_table :autoresponders, id: :uuid do |t|
      t.uuid "project_id"
      t.uuid "organization_id"
      t.string :scope
      t.text :text
      t.timestamps

      t.index ["organization_id"], name: "index_autoresponders_on_organization_id"
      t.index ["project_id"], name: "index_autoresponders_on_project_id"
    end
  end
end
