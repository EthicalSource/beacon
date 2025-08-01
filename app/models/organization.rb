class Organization < ApplicationRecord
  validates_uniqueness_of :name
  validates_uniqueness_of :slug
  validates_presence_of :name

  belongs_to :account
  has_one :autoresponder, dependent: :destroy
  has_one :consequence_guide, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :roles, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_one :respondent_template, dependent: :destroy

  before_create :set_slug
  after_create :create_consequence_guide
  after_save :update_project_org_names
  after_save :update_project_settings

  attr_accessor :default_source

  def autoresponder?
    autoresponder.present?
  end

  def consequence_guide?
    consequence_guide.consequences.any?
  end

  def flag!(reason)
    self.update(
      is_flagged: true,
      flagged_reason: reason,
      flagged_at: Time.zone.now
    )
    projects.each { |project| project.flag!("Organization flagged") }
  end

  def unflag!
    self.update(
      is_flagged: false,
      flagged_reason: nil,
      flagged_at: nil
    )
    projects.each(&:unflag!)
  end

  def flagged?
    !!is_flagged
  end

  def moderator?(account)
    moderators.include?(account)
  end

  def moderators
    roles.where("is_default_moderator = ? OR is_owner = ?", true, true).map(&:account)
  end

  def owner?(account)
    owners.include?(account)
  end

  def owners
    roles.where(is_owner: true).includes(:account).map(&:account)
  end

  def respondent_template?
    respondent_template.present?
  end

  def setup_complete?
    respondent_template && consequence_guide? && autoresponder?
  end

  def toggle_flagged
    self.update_attribute(:is_flagged, !is_flagged)
  end

  def to_param
    slug
  end

  private

  def create_consequence_guide
    ConsequenceGuide.create(organization_id: id)
  end

  def set_slug
    self.slug = name.downcase.gsub(/[^a-z0-9]/i, '_').gsub(Unicode::Emoji::REGEX, '').gsub(/[_]+/, '_')
  end

  def update_project_org_names
    return unless projects.any?
    return if projects.first.organization_name == name
    projects.each{ |project| project.update_attribute(:organization_name, name) }
  end

  def update_project_settings
    projects.each{ |project| project.update_attribute(:accept_issues_by_email, accept_issues_by_email) }
  end

end
