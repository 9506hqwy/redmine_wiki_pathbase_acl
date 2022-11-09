# frozen_string_literal: true

module RedmineWikiPathbaseAcl
  module Utils
    if ActiveRecord::VERSION::MAJOR >= 5
      Migration = ActiveRecord::Migration[4.2]
    else
      Migration = ActiveRecord::Migration
    end

    def self.permit_page?(page, user, permission)
      return true if user.admin

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
