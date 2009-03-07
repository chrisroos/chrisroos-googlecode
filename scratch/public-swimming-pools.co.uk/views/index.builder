xml = Builder::XmlMarkup.new(:indent => 2)
xml.instruct! :xml
xml.kml(:xmlns => "http://earth.google.com/kml/2.2", 'xmlns:atom' => "http://www.w3.org/2005/Atom") do
  xml.Document {
    xml.name
    @sites.each do |site|
      xml.Placemark {
        xml.name(site.name.titleize)
        xml.description site.telephone
        xml.Point {
          xml.coordinates "#{site.longitude},#{site.latitude}"
        }
      }
    end
  }
end