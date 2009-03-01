module ActivePlacesHelper
  
  ACTIVE_PLACES_COOKIE_FILE = File.join(Rails.root, 'tmp', 'activeplaces.cookie')
  SEARCH_FORM_HTML_FILE = File.join(Rails.root, 'data', 'search-form.html')
  
  def create_file_with_metadata(filename, data)
    datetime = Time.now.strftime("%Y%d%m%H%M%S")
    File.open(filename, 'w') { |f| f.puts(data) }
    File.open("#{filename}.updated_at", 'w') { |f| f.puts(datetime) }
  end
  
end