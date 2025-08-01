module Permissions

  def can_access_abuse_reports?
    !!is_admin
  end

  def can_access_admin_dashboard?
    !!is_admin
  end

  def can_access_admin_account_dashboard?
    !!is_admin
  end

  def can_access_admin_organization_dashboard?
    !!is_admin
  end

  def can_access_admin_project_dashboard?
    !!is_admin
  end

  def can_block_account?(project)
    return true if project.all_moderators.include?(self)
    false
  end

  def can_comment_on_issue?(issue)
    project = issue.project
    return true if issue.project.all_moderators.include?(self)
    return false if blocked_from_project?(project)
    return true if issue.reporter == self
    return true if issue.respondent == self
    false
  end

  def can_create_organization?
    !is_flagged
  end

  def can_create_project?
    !is_flagged
  end

  def can_complete_survey_on_issue?(issue, project)
    return false if is_external_reporter
    return false unless issue.respondent == self || issue.reporter == self
    return !project.surveys.select{ |s| s.issue == issue }.map(&:account).find{ |account| account == self }.present?
  end

  def can_invite_moderator?(subject)
    return false if subject.is_a?(Organization) && !subject.owner?(self)
    return true if subject.is_a?(Project) && subject.organization && subject.organization.owner?(self)
    return false if subject.is_a?(Project) && !subject.owner?(self)
    return true
  end

  def can_invite_respondent?(issue)
    issue.project.moderator?(self)
  end

  def can_lock_account?
    !!is_admin
  end

  def can_lock_organization?
    !!is_admin
  end

  def can_lock_project?
    !!is_admin
  end

  def can_manage_project_autoresponder?(project)
    return false unless project.present?
    project.moderator?(self)
  end

  def can_manage_project_consequence_guide?(project)
    return false unless project.present?
    project.moderator?(self)
  end

  def can_manage_project_respondent_template?(project)
    project.moderator?(self)
  end

  def can_manage_organization_autoresponder?(organization)
    return false unless organization.present?
    organization.owner?(self)
  end

  def can_manage_organization_consequence_guide?(organization)
    return false unless organization.present?
    organization.owner?(self)
  end

  def can_manage_organization_respondent_template?(organization)
    organization.owner?(self)
  end

  def can_moderate_project?(project)
    project.moderator?(self)
  end

  def can_remove_moderator?(subject)
    subject.owner?(self)
  end

  def can_view_organization?(organization)
    organization.owners.include?(self) || organization.moderators.include?(self)
  end

  def can_manage_organization?(organization)
    return false unless organization
    organization.owners.include? self
  end

  def can_manage_project?(project)
    project.owners.include? self
  end

  def can_open_issue_on_project?(project)
    return false if is_flagged
    return false unless project.accepting_issues?
    return false if project.require_3rd_party_auth? && !third_party_credentials?
    return false if blocked_from_project?(project)
    return false if project.issue_count_from_past_24_hours == project.project_setting.rate_per_day
    return false if issues.submitted.past_24_hours.count == ENV.fetch('MAX_ISSUES_PER_DAY').to_i
    return true
  end

  def can_report_abuse?(project)
    return false if is_flagged
    submitted = abuse_reports.submitted
    return false if submitted.count >= ENV.fetch('MAX_ABUSE_REPORTS_PER_DAY').to_i
    return false if submitted.map(&:abuse_report_subject).select{ |ars| ars.project_id = project.id }.any?
    true
  end

  def can_upload_images_to_issue?(issue)
    issue.reporter == self
  end

  def can_view_issue?(issue)
    project = issue.project
    return false if issue.blocked_moderator?(self)
    return true if is_admin?
    return true if project.moderator?(self)
    return false if blocked_from_project?(project)
    return true if issue.reporter == self
    return true if issue.respondent == self
    false
  end

  def can_view_survey_on_issue?(project)
    return true if is_admin?
    return true if project.all_moderators.include?(self)
    false
  end

end
