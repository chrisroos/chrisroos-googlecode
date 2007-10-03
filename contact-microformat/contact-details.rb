require 'rubygems'
require 'hpricot'

class ContactParser
  def self.from_html(html)
    doc = Hpricot(html)
    new(doc)
  end
  def initialize(hpricot_doc)
    @hpricot_doc = hpricot_doc
  end
  def service_identifiers
    (@hpricot_doc/'.contactDetails .identifier').inject({}) do |hash, e|
       service = (e.classes - ['identifier']).first
       identifier = e.inner_text
       hash[service] = identifier
       hash
    end
  end
  def identifier(service)
    (@hpricot_doc/".contactDetails .#{service}.identifier").inner_text
  end
end

html = File.open('/Users/chrisroos/Desktop/contact-details.html') { |f| f.read }
parser = ContactParser.from_html(html)

p parser.service_identifiers
# => {"skype"=>"skype-username", "msn"=>"msn-username"}
p parser.identifier('skype')
# => 'skype-username'
p parser.identifier('blurgh')
# => ''