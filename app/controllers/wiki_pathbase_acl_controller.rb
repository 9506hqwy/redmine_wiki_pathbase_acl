# frozen_string_literal: true

class WikiPathbaseAclController < ApplicationController
  before_action :find_project_by_project_id, :authorize

  def update
    req_acls = params[:acls] || []
    new_acls = []
    req_acls.each do |req_acl|
      next if req_acl['path'].blank?

      acl = WikiPathbaseAcl.new
      acl.project = @project
      if req_acl['who'].present?
        who = req_acl['who']
        case who.slice!(0)
        when 'u'
          acl.user = User.find(who)
        when 'r'
          acl.role = Role.find(who)
        end
      end
      acl.path = req_acl['path']
      acl.permission = req_acl['permission']
      acl.control = req_acl['control']
      new_acls << acl
    end

    new_acls.each_with_index do |acl, i|
      acl.order = i
    end

    @project.wiki_acls = new_acls
    flash[:notice] = l(:notice_successful_update)
    redirect_to settings_project_path(@project, tab: :wiki_pathbase_acl)
  end
end
