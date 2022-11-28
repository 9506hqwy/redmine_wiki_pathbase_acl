# frozen_string_literal: true

module RedmineWikiPathbaseAcl
  module ProjectsHelperPatch
    def project_settings_tabs
      action = {
        name: 'wiki_pathbase_acl',
        controller: :wiki_pathbase_acl,
        action: :update,
        partial: 'wiki_pathbase_acl/show',
        label: :wiki_pathbase_acl,
      }

      tabs = super
      tabs << action if User.current.allowed_to?(action, @project)
      tabs
    end
  end
end

Rails.application.config.after_initialize do
  ProjectsController.send(:helper, RedmineWikiPathbaseAcl::ProjectsHelperPatch)
end
