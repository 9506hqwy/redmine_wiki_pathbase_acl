# frozen_string_literal: true

module RedmineWikiPathbaseAcl
  module RolePatch
    def self.prepended(base)
      base.class_eval do
        has_many(:wiki_acls, class_name: :WikiPathbaseAcl, dependent: :destroy)
      end
    end
  end
end

Role.prepend RedmineWikiPathbaseAcl::RolePatch
