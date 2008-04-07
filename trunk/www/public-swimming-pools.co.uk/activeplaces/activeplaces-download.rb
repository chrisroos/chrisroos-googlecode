BASE_URL = 'http://activeplaces.com'
SITE_ID = 1000081 #1004549
COOKIE_JAR = '/Users/chrisroos/Desktop/activeplaces.cookie'
OUTPUT_DIR = File.join('/', 'Users', 'chrisroos', 'Desktop', 'activeplaces-data')

def curl(cmd)
  cmd = "curl #{cmd} -s" # -s = silent
  # p cmd
  `#{cmd}`
end

# curl %%"#{BASE_URL}/Index_lowgraphic.asp" -c"#{COOKIE_JAR}"%
# 
# facility_html = curl %%"#{BASE_URL}/siteinfo/moreinfo_lowgraphic.asp?siteid=#{SITE_ID}" \
# -b"#{COOKIE_JAR}"%
# 
# File.open(File.join(OUTPUT_DIR, "#{SITE_ID}.html"), 'w') { |f| f.puts(facility_html) }

require 'hpricot'

facility_html = File.open(File.join(OUTPUT_DIR, "#{SITE_ID}.html")) { |f| f.read }

doc = Hpricot(facility_html)
(doc/'div.tabArea'/'a.tab').each do |tab_anchor|
  iframe_src = tab_anchor.attributes['href']
  facility_type_id = iframe_src[/FacilityTypeId=(\d+)/, 1] || 'unknown_type'
  iframe_html = curl %%"#{BASE_URL}/siteinfo/#{iframe_src}" -b"#{COOKIE_JAR}"%
  filename = File.join(OUTPUT_DIR, "#{SITE_ID}_#{facility_type_id}.html"
  raise "FILENAME '#{filename}' ALREADY EXISTS" if File.exists?(filename)
  File.open(filename), 'w') { |f| f.puts(iframe_html) }
end