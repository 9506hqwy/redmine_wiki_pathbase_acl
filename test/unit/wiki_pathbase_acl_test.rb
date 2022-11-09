# frozen_string_literal: true

require File.expand_path('../../test_helper', __FILE__)

class WikiPathbaseAclTest < ActiveSupport::TestCase
  fixtures :member_roles,
           :members,
           :projects,
           :roles,
           :users,
           :wiki_pathbase_acls

  def test_create
    p = projects(:projects_001)

    a = WikiPathbaseAcl.new
    a.project = p
    a.path = 'a'
    a.permission = 'b'
    a.order = 1
    a.control = 'allow'
    a.save!

    a.reload
    assert_equal p.id, a.project_id
    assert_equal 'a', a.path
    assert_equal 'b', a.permission
    assert_equal 1, a.order
    assert_equal 'allow', a.control
  end

  def test_update
    p = projects(:projects_002)

    a = p.wiki_acls.first
    a.path = 'c'
    a.permission = 'd'
    a.order = 2
    a.control = 'deny'
    a.save!

    a.reload
    assert_equal p.id, a.project_id
    assert_equal 'c', a.path
    assert_equal 'd', a.permission
    assert_equal 2, a.order
    assert_equal 'deny', a.control
  end

  def test_match
    user = users(:users_001)
    a = WikiPathbaseAcl.new
    a.path = 'a'
    a.permission = 'b'
    assert_equal true, a.match(user, 'a', :b)
  end

  def test_match_path
    user = users(:users_001)
    a = WikiPathbaseAcl.new

    a.path = 'a'
    assert_equal true, a.match_path?('A', user)
    assert_equal false, a.match_path?('B', user)

    a.path = ':{user}'
    assert_equal true, a.match_path?('admin', user)
    assert_equal false, a.match_path?('jsmith', user)
  end

  def test_match_permission
    a = WikiPathbaseAcl.new

    a.permission = 'a'
    assert_equal true, a.match_permission?(:a)
    assert_equal false, a.match_permission?(:b)
  end

  def test_match_role
    user2 = users(:users_002)
    user3 = users(:users_003)
    role = roles(:roles_001)
    a = WikiPathbaseAcl.new
    a.project = projects(:projects_001)

    assert_equal true, a.match_role?(user2)
    assert_equal true, a.match_role?(user3)

    a.role = role
    assert_equal true, a.match_role?(user2)
    assert_equal false, a.match_role?(user3)
  end

  def test_match_user
    user1 = users(:users_001)
    user2 = users(:users_002)
    a = WikiPathbaseAcl.new

    assert_equal true, a.match_user?(user1)
    assert_equal true, a.match_user?(user2)

    a.user = user1
    assert_equal true, a.match_user?(user1)
    assert_equal false, a.match_user?(user2)
  end
end
