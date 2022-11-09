# frozen_string_literal: true

require File.expand_path('../../test_helper', __FILE__)

class ProjectTest < ActiveSupport::TestCase
  fixtures :projects,
           :wiki_pathbase_acls

  def test_destroy
    p = projects(:projects_002)
    p.destroy!

    begin
      wiki_pathbase_acls(:wiki_pathbase_acls_001)
      assert false
    rescue ActiveRecord::RecordNotFound
      assert true
    end
  end
end
