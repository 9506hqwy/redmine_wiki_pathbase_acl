# frozen_string_literal: true

basedir = File.expand_path('../lib', __FILE__)
libraries =
  [
    'redmine_wiki_pathbase_acl/utils',
    'redmine_wiki_pathbase_acl/projects_helper_patch',
    'redmine_wiki_pathbase_acl/project_patch',
    'redmine_wiki_pathbase_acl/wiki_controller_patch',
  ]

libraries.each do |library|
  require_dependency File.expand_path(library, basedir)
end

Redmine::Plugin.register :redmine_wiki_pathbase_acl do
  name 'Redmine Wiki Path Base ACL plugin'
  author '9506hqwy'
  description 'This is Wiki path base ACL plugin for Redmine'
  version '0.1.0'
  url 'https://github.com/9506hqwy/redmine_wiki_pathbase_acl'
  author_url 'https://github.com/9506hqwy'

  project_module :wiki_pathbase_acl do
    permission :edit_wiki_pathbase_acl, {wiki_pathbase_acl: [:update]}
  end
end
