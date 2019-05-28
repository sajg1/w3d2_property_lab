require('pry-byebug')
require_relative('models/property_tracker')

property_1 = Property.new({
  'address' => "71 Bonaly Rise",
  'value' => "200",
  'year_built' => '1970',
  'square_footage' => '400'
})

property_2 = Property.new({
  'address' => "123 Haymarket Avenue",
  'value' => "1000",
  'year_built' => '1960',
  'square_footage' => '700'
})

property_2.create()

binding.pry
nil
