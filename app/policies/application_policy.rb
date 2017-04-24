class ApplicationPolicy
  attr_reader :member, :record

  def initialize(member, record)
    @member  = member
    @record  = record
  end

  private

  def standard_policy(action)
    member.admin? || member.owner? || verify_scope(action)
  end

  def verify_scope(current_action)
    scope = "#{current_class}/#{current_action}"
    member.scopes.include?(scope)
  end

  def current_class
    return record.model_name.plural if record.class == Class
    record.class.to_s.downcase.pluralize
  end
end
