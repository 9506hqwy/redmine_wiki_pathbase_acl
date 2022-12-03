# frozen_string_literal: true

module RedmineWikiPathbaseAcl
  module WikiPagePatch
    def wiki_pathbase_acl_editable_by?(user)
      !protected? || Utils.permit_page?(self, user, :protect_wiki_pages)
    end

    def visible_wiki_pathbase_acl?(user)
      Utils.permit_page?(self, user, :view_wiki_pages)
    end
  end

  module WikiPagePatch4
    include WikiPagePatch

    def self.included(base)
      base.class_eval do
        alias_method_chain(:editable_by?, :wiki_pathbase_acl)
        alias_method_chain(:visible?, :wiki_pathbase_acl)
      end
    end

    def editable_by_with_wiki_pathbase_acl?(user)
      return false unless wiki_pathbase_acl_editable_by?(user)

      editable_by_without_wiki_pathbase_acl?(user)
    end

    def visible_with_wiki_pathbase_acl?(user=User.current)
      return false unless visible_wiki_pathbase_acl?(user)

      visible_without_wiki_pathbase_acl?(user)
    end
  end

  module WikiPagePatch5
    include WikiPagePatch

    def editable_by?(user=User.current)
      return false unless wiki_pathbase_acl_editable_by?(user)

      super
    end

    def visible?(user=User.current)
      return false unless visible_wiki_pathbase_acl?(user)

      super
    end
  end
end

if ActiveSupport::VERSION::MAJOR >= 5
  WikiPage.prepend RedmineWikiPathbaseAcl::WikiPagePatch5
else
  WikiPage.include RedmineWikiPathbaseAcl::WikiPagePatch4
end
