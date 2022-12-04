# frozen_string_literal: true

require File.expand_path('../../test_helper', __FILE__)

class UserTest < ActiveSupport::TestCase
  fixtures :users,
           :wiki_pathbase_acls

  def test_destroy
    a = wiki_pathbase_acls(:wiki_pathbase_acls_001)
    u = users(:users_002)
    a.user = u
    a.save!

    u.destroy!

    begin
      a.reload
      assert false
    rescue ActiveRecord::RecordNotFound
      assert true
    end
  end
end
