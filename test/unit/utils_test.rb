# frozen_string_literal: true

require File.expand_path('../../test_helper', __FILE__)

class UtilsTest < ActiveSupport::TestCase
  fixtures :projects,
           :users,
           :wiki_pages,
           :wikis,
           :wiki_pathbase_acls

  def test_permit_page_admin
    acl = WikiPathbaseAcl.new
    acl.path = ".+"
    acl.permission = 'a'
    acl.control = 'deny'
    acl.order = 0

    project = projects(:projects_001)
    project.wiki_acls = [acl]

    page = wiki_pages(:wiki_pages_001)
    user1 = users(:users_001)
    user2 = users(:users_002)

    assert_equal true, RedmineWikiPathbaseAcl::Utils.permit_page?(page, user1, :a)
    assert_equal false, RedmineWikiPathbaseAcl::Utils.permit_page?(page, user2, :a)
  end

  def test_permit_page_not_match
    acl = WikiPathbaseAcl.new
    acl.path = ".+"
    acl.permission = 'b'
    acl.control = 'deny'
    acl.order = 0

    project = projects(:projects_001)
    project.wiki_acls = [acl]

    page = wiki_pages(:wiki_pages_001)
    user2 = users(:users_002)

    assert_equal true, RedmineWikiPathbaseAcl::Utils.permit_page?(page, user2, :a)
  end

  def test_permit_page_order
    acl1 = WikiPathbaseAcl.new
    acl1.path = ".+"
    acl1.permission = 'a'
    acl1.control = 'deny'
    acl1.order = 0

    acl2 = WikiPathbaseAcl.new
    acl2.path = ".+"
    acl2.permission = 'b'
    acl2.control = 'allow'
    acl2.order = 1

    project = projects(:projects_001)
    project.wiki_acls = [acl1, acl2]

    page = wiki_pages(:wiki_pages_001)
    user2 = users(:users_002)

    assert_equal false, RedmineWikiPathbaseAcl::Utils.permit_page?(page, user2, :a)
  end
end
