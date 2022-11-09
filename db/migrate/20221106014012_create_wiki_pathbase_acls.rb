# frozen_string_literal: true

class CreateWikiPathbaseAcls < RedmineWikiPathbaseAcl::Utils::Migration
  def change
    create_table :wiki_pathbase_acls do |t|
      t.belongs_to :project, null: false, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.belongs_to :role, foreign_key: true
      t.string :path, null: false
      t.string :permission, null: false
      t.string :control, null: false
      t.integer :order, null: false
    end
  end
end
