class AutorespondersController < ApplicationController

  before_action :authenticate_account!
  before_action :scope_organization
  before_action :scope_project
  before_action :enforce_permissions
  before_action :scope_autoresponder, only: [:edit, :show, :update]
  before_action :scope_available_sources, only: [:new, :edit, :clone]

  def new
    if organization = @organization || @project.organization
      breadcrumb "Organizations", organizations_path
      breadcrumb organization.name, organization_path(organization)
    else
      breadcrumb "Projects", projects_path
    end
    breadcrumb(@project.name, project_path(@project)) if @project
    if @project
      @autoresponder = Autoresponder.new(project_id: @project.id)
      org_autoresponder = @project.organization.present? ? "Organization Default" : nil
    else
      @autoresponder = Autoresponder.new(organization_id: @organization.id)
    end
    @available_sources = ["Beacon Default", org_autoresponder, @available_sources].flatten.compact - [@project&.name]
  end

  def show
    if organization = @organization || @project.organization
      breadcrumb "Organizations", organizations_path
      breadcrumb organization.name, organization_path(organization)
    else
      breadcrumb "Projects", projects_path
    end
    breadcrumb(@project.name, project_path(@project)) if @project
  end

  def create
    if @project
      @template = Autoresponder.new(respondent_template_params.merge(project_id: @project.id))
    elsif @organization
      @template = Autoresponder.new(respondent_template_params.merge(organization_id: @organization.id))
    end
    if @template.save
      flash[:notice] = "You have successfully created an autoresponder."
      redirect_to project_path(@project) if @project
      redirect_to organization_path(@organization) if @organization
    else
      flash[:error] = @template.errors.full_messages
      render :new
    end
  end

  def clone
    if existing = @subject.respondent_template
      existing.destroy
    end
    source = autoresponder_params[:default_source]
    if source == "Beacon Default"
      @template = @subject.create_autoresponder(text: Autoresponder.beacon_default.text)
    elsif source == "Organization Default"
      @template = @subject.create_autoresponder(
        text: @organization&.autoresponder&.text ||
          @project.organization.autoresponder.text
      )
    else
      source = current_account.projects.find{ |p| p.name == source }.autoresponder
      @template = @subject.create_autoresponder(text: source.text)
    end
    flash[:notice] = "You have successfully updated the autoresponder."
    if @project
      redirect_to project_autoresponder_path(@project)
    else
      redirect_to organization_autoresponder_path(@organization)
    end
  end

  def edit
    if organization = @organization || @project.organization
      breadcrumb "Organizations", organizations_path
      breadcrumb organization.name, organization_path(organization)
    else
      @available_sources = ["Beacon Default", @available_sources].flatten.compact - [@project&.name]
      breadcrumb "Projects", projects_path
    end
    breadcrumb(@project.name, project_path(@project)) if @project
  end

  def update
    if @autoresponder.update(autoresponder_params)
      flash[:notice] = "You have successfully updated the autoresponder."
      redirect_to @subject
    else
      flash[:error] = @autoresponder.errors.full_messages
    end
  end

  private

  def enforce_permissions
    render_forbidden && return if @project && !current_account.can_manage_project_autoresponder?(@project)
    render_forbidden && return if @organization && !current_account.can_manage_organization_autoresponder?(@organization)
  end

  def autoresponder_params
    params.require(:autoresponder).permit(:text, :default_source)
  end

  def scope_autoresponder
    @autoresponder = @subject.autoresponder
  end

  def scope_available_sources
    if @project&.organization
      projects_with_autoresponder = @project.organization.projects.select(&:autoresponder?)
    elsif @organization
      projects_with_autoresponder = @organization.projects.select(&:autoresponder?)
    end
    projects_with_autoresponder ||= current_account.personal_projects.select(&:autoresponder?)
    @available_sources = projects_with_autoresponder.map(&:name).flatten
  end

  def scope_organization
    @organization = Organization.find_by(slug: params[:organization_slug])
    @subject = @organization
  end

  def scope_project
    @project = Project.find_by(slug: params[:project_slug])
    @subject ||= @project
  end

end
