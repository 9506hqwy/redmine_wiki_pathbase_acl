# frozen_string_literal: true

module RedmineWikiPathbaseAcl
  module MacroPatch
    def self.wiki_pathbase_acl_include(args, project, &block)
      page = Wiki.find_page(args.first.to_s, :project => project)
      raise 'Access Denied' if page.present? && !Utils.permit_page?(page, User.current, :view_wiki_pages)

      yield
    end
  end

  module MacroPatch4
    def self.included(base)
      base.class_eval do
        alias_method_chain(:macro_include, :wiki_pathbase_acl)
      end
    end

    def macro_include_with_wiki_pathbase_acl(obj, args)
      MacroPatch.wiki_pathbase_acl_include(args, @project) do
        macro_include_without_wiki_pathbase_acl(obj, args)
      end
    end
  end

  module MacroPatch5
    def self.included(base)
      base.class_eval do
        alias_method(:macro_include_without_wiki_pathbase_acl, :macro_include)
        alias_method(:macro_include, :macro_include_with_wiki_pathbase_acl)
      end
    end

    def macro_include_with_wiki_pathbase_acl(obj, args)
      MacroPatch.wiki_pathbase_acl_include(args, @project) do
        macro_include_without_wiki_pathbase_acl(obj, args)
      end
    end
  end
end

if ActiveSupport::VERSION::MAJOR >= 5
  Redmine::WikiFormatting::Macros::Definitions.include RedmineWikiPathbaseAcl::MacroPatch5
else
  Redmine::WikiFormatting::Macros::Definitions.include RedmineWikiPathbaseAcl::MacroPatch4
end
