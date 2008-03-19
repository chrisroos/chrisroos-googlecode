require 'yaml'

class Trackbacks
  
  DataLocation = File.join(DATA_DIRECTORY, 'trackbacks.yml')
  
  class << self
    def create(trackback)
      trackbacks = from_yaml_file(DataLocation)
      trackbacks.add(trackback)
      trackbacks.save
    end
  
    def find_all
      from_yaml_file(DataLocation)
    end
  
    def from_yaml_file(filename)
      File.open(DataLocation, 'w') { |f| f.puts [].to_yaml } unless File.exists?(DataLocation)
      new YAML.load_file(filename)
    end
    private :from_yaml_file
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
  
  def save
    to_yaml_file(DataLocation)
  end
  
  def to_yaml_file(filename)
    File.open(filename, 'w') { |f| f.puts(@trackbacks.to_yaml) }
  end
  private :to_yaml_file
  
end