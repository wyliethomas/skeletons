module AdminPrivileges
  extend ActiveSupport::Concern

  def can_manage_credits?
    super_admin?
  end

  def can_view_all_clients?
    super_admin?
  end

  def can_manage_team?
    admin? || super_admin?
  end

  def can_approve_cards?
    true # All users can approve for now
  end
end
