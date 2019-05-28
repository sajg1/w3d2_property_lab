require('pg')

class Property

  attr_accessor :address, :value, :year_built, :square_footage
  attr_reader :id

  def initialize(options)

    @address = options['address']
    @value = options['value'].to_i
    @year_built = options['year_built']
    @square_footage = options['square_footage'].to_i
    @id = options['id'].to_i if options['id']
  end

  # Create
  def create()
    db = PG.connect({ dbname: 'property', host: 'localhost' })

    sql = "INSERT INTO properties(address, value, year_built, square_footage) VALUES ($1, $2, $3, $4) RETURNING *"

    values = [@address, @value, @year_built, @square_footage]

    db.prepare('create', sql)
    create_property = db.exec_prepared('create', values)

    @id = create_property[0]['id'].to_i

    db.close()

  end

  def update()
    db = PG.connect({ dbname: 'property', host: 'localhost' })
    sql = "UPDATE properties SET (address, value, year_built, square_footage) = ($1,$2,$3,$4) WHERE id = $5"
    values = [@address, @value, @year_built, @square_footage, @id]
    db.prepare('update', sql)
    db.exec_prepared('update', values)
    db.close()
  end

  def delete()
    db = PG.connect({ dbname: 'property', host: 'localhost' })
    sql = "DELETE FROM properties WHERE id = $1"
    values = [@id]
    db.prepare('delete_single', sql)
    db.exec_prepared('delete_single', values)
    db.close()
  end


  def Property.all()
    db = PG.connect({ dbname: 'property', host: 'localhost' })
    sql = "SELECT * FROM properties"
    db.prepare('add', sql)
    all_properties = db.exec_prepared('add')
    db.close()

    return all_properties.map {|property| Property.new(property)}
  end

  def Property.delete_all()

    db = PG.connect({ dbname: 'property', host: 'localhost' })
    sql = "DELETE FROM properties"
    db.prepare("delete", sql)
    db.exec_prepared("delete")
    db.close()

  end

  def Property.find(id)

    db = PG.connect({ dbname: 'property', host: 'localhost' })
    sql = "SELECT * FROM properties WHERE id = $1"
    values = [id]
    db.prepare("find", sql)
    found_properties = db.exec_prepared("find", values)
    db.close()

    return found_properties.map {|property| Property.new(property)}

  end

  def Property.find_by_address(address)
    db = PG.connect({ dbname: 'property', host: 'localhost' })
    sql = "SELECT * FROM properties WHERE address = $1"
    values = [address]
    db.prepare("find_address", sql)
    found_property = db.exec_prepared("find_address", values)
    db.close()

    found_property_hash = found_property[0]
    result = Property.new(found_property_hash)
    return result
# This doesn't seem to give nil if you search for a property that doesn't exist
    # return found_property.map {|property| Property.new(property)}
  end

end
