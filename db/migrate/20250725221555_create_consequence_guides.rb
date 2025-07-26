class CreateConsequenceGuides < ActiveRecord::Migration[8.0]
  def change
    create_table :consequence_guides, id: :uuid do |t|
      t.uuid "organization_id"
      t.uuid "project_id"
      t.string "scope"
      t.timestamps
      t.index ["organization_id"], name: "index_consequence_guides_on_organization_id"
      t.index ["project_id"], name: "index_consequence_guides_on_project_id"
    end
  end
end
