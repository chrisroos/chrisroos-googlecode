require 'yaml'

class Trackbacks
  
  def self.from_yaml_file(filename)
    new YAML.load_file(filename)
  end
  
  def initialize(trackbacks = [])
    @trackbacks = trackbacks
  end
  
  def add(trackback)
    @trackbacks << trackback
  end
  
  def each(&blk)
    @trackbacks.each(&blk)
  end
  
  def to_yaml_file(filename)
    File.open(filename, 'w') { |f| f.puts(@trackbacks.to_yaml) }
  end
  
end