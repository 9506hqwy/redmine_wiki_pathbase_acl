# frozen_string_literal: true

module RedmineWikiPathbaseAcl
  module ApplicationHelperPatch
    def authorize_for(controller, action)
      return false unless wiki_pathbase_acl_authorize_for(controller, action)

      super
    end

    def wiki_pathbase_acl_authorize_for(controller, action)
      return true if @page.nil?

      action = "#{controller}/#{action}"
      Redmine::AccessControl.permissions.each do |permission|
        if permission.actions.include?(action)
          return RedmineWikiPathbaseAcl::Utils.permit_page?(@page, User.current, permission.name)
        end
      end

      true
    end
  end
end

Rails.application.config.after_initialize do
  WikiController.send(:helper, RedmineWikiPathbaseAcl::ApplicationHelperPatch)
end
