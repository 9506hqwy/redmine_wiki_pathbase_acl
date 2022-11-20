# frozen_string_literal: true

require File.expand_path('../../test_helper', __FILE__)

class WikiTest < Redmine::IntegrationTest
  include Redmine::I18n

  fixtures :enabled_modules,
           :enumerations,
           :member_roles,
           :members,
           :projects,
           :roles,
           :users,
           :wiki_content_versions,
           :wiki_contents,
           :wiki_pages,
           :wikis,
           :wiki_pathbase_acls

  def setup
    Project.find(1).enable_module!(:wiki_pathbase_acl)
  end

  def test_show
    log_user('jsmith', 'jsmith')

    get('/projects/ecookbook/wiki/CookBook_documentation/')

    assert_response :success

    acl = WikiPathbaseAcl.new
    acl.project = Project.find(1)
    acl.path = 'documentation'
    acl.permission = 'view_wiki_pages'
    acl.order = 1
    acl.control = 'deny'
    acl.save!

    get('/projects/ecookbook/wiki/CookBook_documentation/')

    assert_response 403
  end

  def test_show_with_macro_include
    w = wiki_contents(:wiki_contents_001)
    w.text = "{{include(Page_with_an_inline_image)}}"
    w.save!

    log_user('jsmith', 'jsmith')

    get('/projects/ecookbook/wiki/CookBook_documentation/')

    assert_response :success
    assert_select 'div.error', 0

    acl = WikiPathbaseAcl.new
    acl.project = Project.find(1)
    acl.path = 'Page_with_an_inline_image'
    acl.permission = 'view_wiki_pages'
    acl.order = 1
    acl.control = 'deny'
    acl.save!

    get('/projects/ecookbook/wiki/CookBook_documentation/')

    assert_response :success
    assert_select 'div.error', 1
  end
end
