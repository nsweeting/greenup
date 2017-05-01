require 'test_helper'

class ZoneTest < ActiveSupport::TestCase
  test 'that a zone can be created' do
    country = create(:country)
    zone = create(:zone)
    byebug
    attr = [{id: country.id}, {id: country.id}]
    assert create(:zone)
    zone.update_attributes! countries_attributes: attr
  end
end
