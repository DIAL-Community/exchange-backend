# frozen_string_literal: true

class CandidateProductPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    super(user, record)
  end

  def available?
    true
  end

  def create_allowed?
    !user.nil?
  end

  def edit_allowed?
    # User is not logged in to the system, now allowed to edit.
    return false if user.nil?
    # User who created the candidate product is allowed to edit.
    return true if user.id == record.created_by_id
    # User is an admin or a candidate editor, allowed to edit.
    user.roles.include?(User.user_roles[:admin]) ||
      user.roles.include?(User.user_roles[:candidate_editor])
  end

  def status_update_allowed?
    # Adding status update permission only to candidate products (and maybe other candidate objects as well?).
    # This is to separate the permission to edit the submission and putting the submission in the approval
    # workflow.

    # User is not logged in to the system, now allowed to edit candidate's status.
    return false if user.nil?
    # User is an admin or a candidate editor, allowed to edit candidate's status.
    user.roles.include?(User.user_roles[:admin]) ||
      user.roles.include?(User.user_roles[:candidate_editor])
  end

  def delete_allowed?
    return false if user.nil?

    user.roles.include?(User.user_roles[:admin])
  end

  def view_allowed?
    # User is not logged in to the system, now allowed to view.
    return false if user.nil?
    # Logged in user is allowed to view candidate product list, but query must be filtered to only show
    # candidate products created by the user.
    puts "User nil: #{user.nil?}"
    puts "Record new: #{record.new_record?}"
    return true if !user.nil? && record.new_record?
    # User who created the candidate product is allowed to view.
    return true if user.id == record.created_by_id
    # User is an admin or a candidate editor, allowed to view.
    user.roles.include?(User.user_roles[:admin]) ||
      user.roles.include?(User.user_roles[:candidate_editor])
  end
end
