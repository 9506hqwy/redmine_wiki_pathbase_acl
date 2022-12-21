# frozen_string_literal: true

class WikiPathbaseAcl < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  belongs_to :role

  def match(user, path, permission)
    return false unless match_user?(user)
    return false unless match_role?(user)
    return false unless match_path?(path, user)

    match_permission?(permission)
  end

  def match_path?(path, user)
    pattern = self.path.gsub(':{user}', Regexp.escape(user.login))
    reg = Regexp.compile(pattern, Regexp::IGNORECASE)
    reg.match(path).present?
  end

  def match_permission?(permission)
    return true if self.permission.to_sym == :all

    self.permission.to_sym == permission
  end

  def match_role?(user)
    return true if self.role.nil?

    self.project.memberships.each do |member|
      next if member.user_id != user.id
      return true if member.roles.include?(self.role)
    end

    false
  end

  def match_user?(user)
    self.user.nil? || self.user_id == user.id
  end

  def permit?
    self.control == 'allow'
  end
end
