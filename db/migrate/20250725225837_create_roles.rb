class CreateRoles < ActiveRecord::Migration[8.0]
  def change
    create_table :roles, id: :uuid do |t|
      t.uuid "account_id"
      t.uuid "organization_id"
      t.uuid "project_id"
      t.boolean "is_owner", default: false
      t.boolean "is_default_moderator", default: false
      t.boolean "can_manage_org", default: false
      t.boolean "can_create_org_projects", default: false
      t.boolean "can_see_historic_issues", default: true
      t.timestamps

      t.index ["account_id"], name: "index_roles_on_account_id"
      t.index ["organization_id"], name: "index_roles_on_organization_id"
      t.index ["project_id"], name: "index_roles_on_project_id"
    end
  end
end
