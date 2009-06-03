module AtomHelper
  
  def atom_datetime(datetime)
    datetime.strftime("%Y-%m-%dT%H:%M:%SZ")
  end
  
  def tag_uri(object)
    "tag:deliciolytics.co.uk,2009:#{object.class}/#{object.id}"
  end
  
end