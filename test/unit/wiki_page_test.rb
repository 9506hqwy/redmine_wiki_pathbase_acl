# frozen_string_literal: true

require File.expand_path('../../test_helper', __FILE__)

class WikiPageTest < ActiveSupport::TestCase
  fixtures :attachments,
           :enabled_modules,
           :enumerations,
           :member_roles,
           :members,
           :projects,
           :roles,
           :users,
           :wiki_pages,
           :wikis,
           :wiki_pathbase_acls

  def setup
    set_tmp_attachments_directory
  end

  def test_attachments_deletable
    user = users(:users_002)
    page = wiki_pages(:wiki_pages_001)

    assert_equal true, page.attachments_deletable?(user)

    acl = WikiPathbaseAcl.new
    acl.project = Project.find(1)
    acl.path = page.title
    acl.permission = 'delete_wiki_pages_attachments'
    acl.order = 1
    acl.control = 'deny'
    acl.save!

    assert_equal false, page.attachments_deletable?(user)
  end

  def test_editable_by
    user = users(:users_002)
    page = wiki_pages(:wiki_pages_001)

    assert_equal true, page.editable_by?(user)

    acl = WikiPathbaseAcl.new
    acl.project = Project.find(1)
    acl.path = page.title
    acl.permission = 'protect_wiki_pages'
    acl.order = 1
    acl.control = 'deny'
    acl.save!

    assert_equal false, page.editable_by?(user)

    page.protected = false
    page.save!

    assert_equal true, page.editable_by?(user)
  end

  def test_visible
    user = users(:users_002)
    page = wiki_pages(:wiki_pages_001)

    assert_equal true, page.visible?(user)

    acl = WikiPathbaseAcl.new
    acl.project = Project.find(1)
    acl.path = page.title
    acl.permission = 'view_wiki_pages'
    acl.order = 1
    acl.control = 'deny'
    acl.save!

    assert_equal false, page.visible?(user)
  end
end
