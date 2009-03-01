module ActivePlacesHelper
  
  SEARCH_FORM_HTML_FILE = File.join(Rails.root, 'data', 'search-form.html')
  
  def create_file_with_metadata(filename, data)
    datetime = Time.now.strftime("%Y%d%m%H%M%S")
    File.open(filename, 'w') { |f| f.puts(data) }
    File.open("#{filename}.#{datetime}", 'w')
  end
  
end