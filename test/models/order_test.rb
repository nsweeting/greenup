require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  test 'that an order can be created' do
    assert create(:order)
  end
end
