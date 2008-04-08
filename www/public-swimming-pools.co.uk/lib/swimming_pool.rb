class SwimmingPool
  
  attr_accessor :name, :address, :postcode, :phone, :fax, :url, :email, :coords
  
  def initialize(attrs)
    attrs.each do |attr, value|
      __send__("#{attr}=", value)
    end
  end
  
  def kml_coordinates
    [longitude, latitude, '0'].join(',')
  end

  def latitude
    @coords.first
  end
  
  def longitude
    @coords.last
  end
  
  def permalink
    [name, address].join(' ').downcase.gsub(/,/, ' ').gsub(/ /, '-').gsub(/[^a-zA-Z0-9-]/, '').squeeze('-')
  end
  
end