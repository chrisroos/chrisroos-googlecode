# *******
# USE TO PRODUCE A FILE OF BOOKMARKS THAT CAN EASILY BE COMPARED TO AN SIMILARLY PRODUCED FILE USING DIFF


Filename = 'FILE_OF_DELICIOUS_BOOKMARKS'

xml = File.open(Filename) { |f| f.read }
require 'hpricot'
require 'yaml'
doc = Hpricot(xml)
output = File.open("#{Filename}.yml", 'w')
(doc/'posts'/'post').each do |post_xml|
  attrs = post_xml.attributes
  attrs['tag'] = attrs.delete('tag').split(' ')
  output.puts attrs.to_yaml
end
output.close