# frozen_string_literal: true

module RedmineWikiPathbaseAcl
  module WikiControllerPatch
    def wiki_pathbase_acl_check(permission, &block)
      if Utils.exist_deny_acl?(@project, User.current, permission)
        deny_access
        return
      end

      yield
    end

    def wiki_pathbase_acl_process(permission, &block)
      unless Utils.permit_page?(@page, User.current, permission)
        deny_access
        return
      end

      yield
    end
  end

  module WikiControllerPatch4
    include WikiControllerPatch

    def self.included(base)
      base.class_eval do
        alias_method_chain(:destroy, :wiki_pathbase_acl)
        alias_method_chain(:destroy_version, :wiki_pathbase_acl)
        alias_method_chain(:export, :wiki_pathbase_acl)
        alias_method_chain(:protect, :wiki_pathbase_acl)
        alias_method_chain(:rename, :wiki_pathbase_acl)
        alias_method_chain(:show, :wiki_pathbase_acl)
      end
    end

    def destroy_with_wiki_pathbase_acl
      wiki_pathbase_acl_process(:delete_wiki_pages) do
        destroy_without_wiki_pathbase_acl
      end
    end

    def destroy_version_with_wiki_pathbase_acl
      wiki_pathbase_acl_process(:delete_wiki_pages) do
        destroy_version_without_wiki_pathbase_acl
      end
    end

    def export_with_wiki_pathbase_acl
      wiki_pathbase_acl_check(:view_wiki_pages) do
        export_without_wiki_pathbase_acl
      end
    end

    def protect_with_wiki_pathbase_acl
      wiki_pathbase_acl_process(:protect_wiki_pages) do
        protect_without_wiki_pathbase_acl
      end
    end

    def rename_with_wiki_pathbase_acl
      wiki_pathbase_acl_process(:rename_wiki_pages) do
        rename_without_wiki_pathbase_acl
      end
    end

    def show_with_wiki_pathbase_acl
      wiki_pathbase_acl_process(:view_wiki_pages) do
        show_without_wiki_pathbase_acl
      end
    end
  end

  module WikiControllerPatch5
    include WikiControllerPatch

    def destroy
      wiki_pathbase_acl_process(:delete_wiki_pages) do
        super
      end
    end

    def destroy_version
      wiki_pathbase_acl_process(:delete_wiki_pages) do
        super
      end
    end

    def export
      wiki_pathbase_acl_check(:view_wiki_pages) do
        super
      end
    end

    def protect
      wiki_pathbase_acl_process(:protect_wiki_pages) do
        super
      end
    end

    def rename
      wiki_pathbase_acl_process(:rename_wiki_pages) do
        super
      end
    end

    def show
      wiki_pathbase_acl_process(:view_wiki_pages) do
        super
      end
    end
  end
end

if ActiveSupport::VERSION::MAJOR >= 5
  WikiController.prepend RedmineWikiPathbaseAcl::WikiControllerPatch5
else
  WikiController.include RedmineWikiPathbaseAcl::WikiControllerPatch4
end
