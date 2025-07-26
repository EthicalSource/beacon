class CreateRespondentTemplates < ActiveRecord::Migration[8.0]
  def change
    create_table :respondent_templates, id: :uuid do |t|
      t.uuid "project_id"
      t.text "text"
      t.boolean "is_beacon_default", default: false
      t.uuid "organization_id"
      t.timestamps

      t.index ["organization_id"], name: "index_respondent_templates_on_organization_id"
      t.index ["project_id"], name: "index_respondent_templates_on_project_id"
    end
  end
end
