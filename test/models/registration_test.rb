require 'test_helper'

class RegistrationTest < ActiveSupport::TestCase
  test 'that a registration creates an account' do
    assert_equal 0, Account.count
    registration = Registration.new(attributes)
    assert registration.save
    assert_equal 1, Account.count
    assert_equal registration.account.owner_email, attributes[:email]
  end

  test 'that a registration can assume account errors' do
    account = create(:account)
    registration = Registration.new(attributes.merge!(name: account.name))
    assert_not registration.save
    assert_equal 1, Account.count
    assert_equal ['Account error: Name has already been taken'], registration.merged_errors.full_messages
  end

  test 'that a registration creates a user' do
    assert_equal 0, User.count
    registration = Registration.new(attributes)
    assert registration.save
    assert_equal 1, User.count
    assert_equal registration.user.email, attributes[:email]
    assert registration.user.password_digest.present?
  end

  test 'that a registration can assume user errors' do
    user = create(:user)
    registration = Registration.new(attributes.merge!(email: user.email))
    assert_not registration.save
    assert_equal 1, User.count
    assert_equal ['User error: Email has already been taken'], registration.merged_errors.full_messages
  end

  test 'that a registration creates a member' do
    assert_equal 0, Member.count
    registration = Registration.new(attributes)
    assert registration.save
    assert_equal 1, Member.count
    assert registration.member.owner?
    assert_equal registration.member.account, registration.account
    assert_equal registration.member.user, registration.user
  end

  private

  def attributes
    {
      email: 'test@email.com',
      password: 'password',
      password_confirmation: 'password',
      name: 'account'
    }
  end
end
