# frozen_string_literal: true

module RedmineWikiPathbaseAcl
  module Utils
    if ActiveRecord::VERSION::MAJOR >= 5
      Migration = ActiveRecord::Migration[4.2]
    else
      Migration = ActiveRecord::Migration
    end

    def self.exist_deny_acl?(project, user, permission)
      return false if user.admin
      return false unless project.module_enabled?(:wiki_pathbase_acl)

      project.wiki_acls.each do |acl|
        mu = acl.match_user?(user) || acl.match_role?(user)
        mp = acl.match_permission?(permission)
        return true if mu && mp && !acl.permit?
      end

      false
    end

    def self.permit_page?(page, user, permission)
      return true if page.nil?
      return true if user.admin
      return true unless page.project.module_enabled?(:wiki_pathbase_acl)

      path = Utils.wiki_full_path(page)

      page.project.wiki_acls.order(:order).each do |acl|
        return acl.permit? if acl.match(user, path, permission)
      end

      true
    end

    def self.wiki_full_path(page)
      path = page.title

      parent = page.parent
      while parent
        path = "#{parent.title}/#{path}"
        parent = parent.parent
      end

      path
    end
  end
end
