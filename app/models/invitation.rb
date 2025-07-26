class Invitation < ApplicationRecord

  belongs_to :account
  belongs_to :project, optional: true
  belongs_to :organization, optional: true

  validates :email, format: URI::MailTo::EMAIL_REGEXP
  validates_uniqueness_of :email, scope: :project
  validates_uniqueness_of :email, scope: :organization

  def subject
    return self.project if self.project_id
    return self.organization if self.organization_id
  end

end
