# 2 - Gym
# 7 - Swimming Pool
# 9 - Golf

DATA_DIR = File.join('/', 'Users', 'chrisroos', 'Desktop', 'activeplaces-data')
SITE_IDS = []

Dir[File.join(DATA_DIR, '*.html')].each do |file|
  if site_id = File.basename(file)[/(^\d+)\.html/, 1]
    # it's a site rather than a facility within the site (ramsgate swimming centre rather than pool or gym)
    SITE_IDS << site_id
  end
end

require 'hpricot'

class Site
  def initialize(site_id)
    @site_id = site_id
  end
  def has_pay_and_play_swimming_pool?
    return false unless has_swimming_pool?
    
    html = File.open(swimming_pool_file) { |f| f.read }
    doc = Hpricot(html)
    (doc/'div#siteInformation'/'a').each do |e| 
      if e.inner_text =~ /Access Policy/i
        if e.next_sibling.inner_text =~ /Pay and play/i
          return true
        end
      end
    end
    return false
  end
  def site_file
    File.join(DATA_DIR, "#{@site_id}.html")
  end
private
  def has_swimming_pool?
    File.exists?(swimming_pool_file)
  end
  def swimming_pool_file
    File.join(DATA_DIR, "#{@site_id}_7.html")
  end
end

SITE_IDS.each do |site_id|
  site = Site.new(site_id)
  if site.has_pay_and_play_swimming_pool?
    p 'site: ' + site_id
    site_html = File.open(site.site_file) { |f| f.read }
    site_html.gsub!(/helptext""/, 'helptext"') # Make the html remotely valid by fixing up the broken class attribute
    doc = Hpricot(site_html)
    (doc/'div#headerInfo'/'table'/'a').each do |a|
      if a.inner_text =~ /address/i
        p 'address'
        p a.following_siblings.collect { |e| e.inner_text }.reject { |t| t.empty? }.to_s
      end
      if a.inner_text =~ /tel/i
        p 'tel'
        p a.next_sibling.inner_text
      end
      if a.inner_text =~ /website/i
        p 'website'
        p a.next_sibling.inner_text
      end
    end
  end
end