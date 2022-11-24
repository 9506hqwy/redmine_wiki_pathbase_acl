# frozen_string_literal: true

module RedmineWikiPathbaseAcl
  module ProjectsHelperPatch
    def wiki_pathbase_acl_setting_tabs(tabs)
      action = {
        name: 'wiki_pathbase_acl',
        controller: :wiki_pathbase_acl,
        action: :update,
        partial: 'wiki_pathbase_acl/show',
        label: :wiki_pathbase_acl,
      }

      tabs << action if User.current.allowed_to?(action, @project)
      tabs
    end
  end

  module ProjectsHelperPatch4
    include ProjectsHelperPatch

    def self.included(base)
      base.class_eval do
        alias_method_chain(:project_settings_tabs, :wiki_pathbase_acl)
      end
    end

    def project_settings_tabs_with_wiki_pathbase_acl
      wiki_pathbase_acl_setting_tabs(project_settings_tabs_without_wiki_pathbase_acl)
    end
  end

  module ProjectsHelperPatch5
    include ProjectsHelperPatch

    def project_settings_tabs
      wiki_pathbase_acl_setting_tabs(super)
    end
  end
end

if ActiveSupport::VERSION::MAJOR >= 5
  Rails.application.config.after_initialize do
    ProjectsController.send(:helper, RedmineWikiPathbaseAcl::ProjectsHelperPatch5)
  end
else
  ProjectsHelper.include RedmineWikiPathbaseAcl::ProjectsHelperPatch4
end
