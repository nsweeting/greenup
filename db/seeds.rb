Country.destoy_all

Country.create(
  [
    { name: 'Canada', abbr: 'CA' }
  ]
)

Province.destroy_all

canada = Country.find_by(name: 'Canada')
canada.provinces.create(
  [
    { name: 'Ontario', abbr: 'ON' }
  ]
)

