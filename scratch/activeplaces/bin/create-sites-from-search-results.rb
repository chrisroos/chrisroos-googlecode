require File.join(File.dirname(__FILE__), '..', 'config', 'environment')
require File.join(File.dirname(__FILE__), 'active_places_helper')
include ActivePlacesHelper

search_result_html_file = File.join(Rails.root, 'data', "search-results-ct11-swimming-pool.html")
html = File.read(search_result_html_file)

require 'hpricot'

doc = Hpricot(html)
(doc/'table').each do |table|
  table_rows = (table/'tr')
  next unless table_rows.length == 5
  
  name = (table/'tr:nth(0) td').inner_text[/\d+\.(.*)/, 1].strip
  id = Integer((table/'tr:nth(1) td:nth(0)').inner_text.strip)
  distance = (table/'tr:nth(1) td:nth(1)').inner_text.strip
  telephone = (table/'tr:nth(3) td:nth(0)').inner_text.sub(/^Tel:/, '').strip
  address = (table/'tr:nth(4) td:nth(0)').inner_text.strip
  site_link = (table/'tr:nth(4) td:nth(1) a:nth(0)').first['href']
  ward_id = Integer(site_link[/wardId=(\d+)/, 1])
  
  attrs = {
    'id' => id,
    'name' => name,
    'telephone' => telephone,
    'address' => address,
    'ward_id' => ward_id
  }
  
  if existing_site = Site.find_by_id(id)
    # Duplicate site
    unless existing_site.attributes == attrs
      raise "There's already a record for the site with Id: #{id}.  Unfortunately the existing attributes don't match the new attributes.  This is probably bad."
    end
  else
    site = Site.new(attrs)
    site.id = id
    site.save!
  end
end