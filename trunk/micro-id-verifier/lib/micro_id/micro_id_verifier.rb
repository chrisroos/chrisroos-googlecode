require 'rubygems'
require 'rubyful_soup'

class MicroIdVerifier
  
  def verify(html, expected_micro_id)
    soup = BeautifulSoup.new(html)
    micro_id_tag = soup.html.head.find('meta', :attrs => {'name' => 'microid'}) rescue nil
    return false unless micro_id_tag
    micro_id_tag['content'] == expected_micro_id
  end
  
end