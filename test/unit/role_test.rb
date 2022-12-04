# frozen_string_literal: true

require File.expand_path('../../test_helper', __FILE__)

class RoleTest < ActiveSupport::TestCase
  fixtures :members,
           :roles,
           :wiki_pathbase_acls

  def test_destroy
    Member.destroy_all

    a = wiki_pathbase_acls(:wiki_pathbase_acls_001)
    r = roles(:roles_001)
    a.role = r
    a.save!

    r.destroy!

    begin
      a.reload
      assert false
    rescue ActiveRecord::RecordNotFound
      assert true
    end
  end
end
