require 'securerandom'

class Issue < ApplicationRecord

  include AASM

  attr_accessor :reporter_id, :project_id, :blocked_moderator_ids

  validates_presence_of :description
  validates :urls, url: true
  validates_with IssueModeratorsValidator

  belongs_to :consequence, optional: true
  belongs_to :reporter_consequence, optional: true, class_name: "Consequence"
  has_many :moderator_blocks
  has_many :issue_events, dependent: :destroy
  has_many :issue_comments, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many_attached :uploads, dependent: :destroy

  before_save :validate_upload_file_type_and_size

  before_create :set_issue_number
  after_create :set_reporter_encrypted_id
  after_create :set_project_encrypted_id
  after_create :block_moderators

  scope :past_24_hours, -> { where("created_at >= ?", Time.zone.now - 24.hours) }

  OPEN_STATUSES = %w{submitted acknowledged reopened}.freeze

  aasm do
    state :submitted, initial: true
    state :acknowledged, before_enter: Proc.new{ |args| log_event(args) }
    state :dismissed,    before_enter: Proc.new{ |args| log_event(args) }
    state :resolved,     before_enter: Proc.new{ |args| log_event(args) }
    state :reopened,     before_enter: Proc.new{ |args| log_event(args) }

    event :acknowledge do
      transitions from: :submitted, to: :acknowledged
    end

    event :dismiss do
      transitions from: [:acknowledged, :reopened], to: :dismissed
    end

    event :resolve do
      transitions from: [:acknowledged, :reopened], to: :resolved
    end

    event :reopen do
      transitions from: [:dismissed, :resolved], to: :reopened
    end
  end

  def blocked_moderators
    @blocked_moderators ||= moderator_blocks.map(&:account)
  end

  def blocked_moderator?(account)
    blocked_moderators.include?(account)
  end

  def comments_visible_to_reporter
    issue_comments.select(&:visible_to_reporter)
  end

  def comments_visible_to_respondent
    issue_comments.select(&:visible_to_respondent)
  end

  def comments_visible_only_to_moderators
    issue_comments.select(&:visible_only_to_moderators)
  end

  def consequence
    Consequence.find(consequence_id)
  rescue StandardError
    nil
  end

  def open?
    OPEN_STATUSES.include?(self.aasm_state)
  end

  def project
    @project ||= Project.find(EncryptionService.decrypt(self.project_encrypted_id))
  end

  def reporter
    @reporter ||= Account.find(EncryptionService.decrypt(self.reporter_encrypted_id))
  end

  def respondent
    return unless self.respondent_encrypted_id

    @respondent ||= Account.find(EncryptionService.decrypt(self.respondent_encrypted_id))
  end

  private

  def block_moderators
    return unless self.blocked_moderator_ids
    self.blocked_moderator_ids.reject(&:empty?).each do |id|
      ModeratorBlock.create(issue_id: self.id, account_id: EncryptionService.decrypt(id))
    end
  end

  def validate_upload_file_type_and_size
    if uploads.count > 5
      uploads[5..-1].each(&:purge)
      errors.add(:uploads, "are limited to 5 or less")
    end
    uploads.each do |upload|
      unless upload.image?
        upload.purge
        errors.add(:uploads, "must be an image file")
      end
      if upload.image? && upload.blob.byte_size > (1024 * 1024)
        upload.purge
        errors.add(:uploads, "must be less than 1MB")
      end
    end
  end

  def set_issue_number
    return if self.issue_number

    # FIXME postgres incompatability, ugly workaround here
    # result = Issue.connection.execute("SELECT nextval('issues_issue_number_seq')")
    # self.issue_number = result[0]['nextval']

    self.issue_number = SecureRandom.uuid
  end

  def set_reporter_encrypted_id
    update_attribute(:reporter_encrypted_id, EncryptionService.encrypt(self.reporter_id))
    AccountIssue.create(account_id: self.reporter_id, issue_id: self.id)
  end

  def set_project_encrypted_id
    update_attribute(:project_encrypted_id, EncryptionService.encrypt(self.project_id))
    ProjectIssue.create(project_id: self.project_id, issue_id: self.id)
  end

  def log_event(args)
    update_attribute(:closed_at, Time.zone.now) if aasm_state == "resolved" || aasm_state == "dismissed"
    IssueEvent.create(
      issue_id: self.id,
      actor_id: args[:account_id],
      event: "Status changed to #{aasm.to_state}"
    )
  end

end
