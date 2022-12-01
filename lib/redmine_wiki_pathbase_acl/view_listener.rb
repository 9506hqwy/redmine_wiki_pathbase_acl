# frozen_string_literal: true

module RedmineWikiPathbaseAcl
  class ViewListener < Redmine::Hook::ViewListener
    render_on :view_layouts_base_body_bottom, partial: 'wiki_pathbase_acl/base_body_bottom'
  end
end
