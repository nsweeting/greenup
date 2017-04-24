class Registration
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :name, :email, :password, :password_confirmation,
                :account, :user, :member

  def save
    ActiveRecord::Base.transaction do
      create_account
      create_user
      create_member
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  def merged_errors
    errors.clear
    [account, user, member].each do |relation|
      next unless relation.present?
      merge_errors_from(relation)
    end
    errors
  end

  private

  def create_account
    self.account = Account.new(name: name, owner_email: email)
    account.save!
  end

  def create_user
    self.user = User.new(email: email, password: password, password_confirmation: password_confirmation)
    user.save!
  end

  def create_member
    self.member = Member.new(account: account, user: user, role: :owner, confirmed: true)
    member.save!
  end

  def merge_errors_from(relation)
    return if relation.valid?
    relation.errors.full_messages.each do |msg|
      errors.add(:base, "#{relation.class} error: #{msg}")
    end
  end
end
