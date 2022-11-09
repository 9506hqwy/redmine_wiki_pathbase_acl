# frozen_string_literal: true

module RedmineWikiPathbaseAcl
  module WikiControllerPatch
    def editable_wiki_pathbase_acl?(page)
      Utils.permit_page?(page, User.current, :edit_wiki_pages)
    end
  end

  module WikiControllerPatch4
    include WikiControllerPatch

    def self.included(base)
      base.class_eval do
        alias_method_chain(:editable?, :wiki_pathbase_acl)
      end
    end

    def editable_with_wiki_pathbase_acl?(page = @page)
      return false unless editable_wiki_pathbase_acl?(page)

      editable_without_wiki_pathbase_acl?(page)
    end
  end

  module WikiControllerPatch5
    include WikiControllerPatch

    def editable?(page = @page)
      return false unless editable_wiki_pathbase_acl?(page)

      super
    end
  end
end

if ActiveSupport::VERSION::MAJOR >= 5
  WikiController.prepend RedmineWikiPathbaseAcl::WikiControllerPatch5
else
  WikiController.include RedmineWikiPathbaseAcl::WikiControllerPatch4
end
