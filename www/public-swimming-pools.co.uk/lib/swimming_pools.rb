require 'yaml'
require File.join(File.dirname(__FILE__), 'swimming_pool')

class SwimmingPools
  
  SwimmingPoolFiles = File.join(File.dirname(__FILE__), *%w[.. data *.yaml])
  
  def self.find_all(swimming_pool_files = SwimmingPoolFiles)
    @swimming_pools ||= (
      Dir[SwimmingPoolFiles].collect do |swimming_pool_file|
        next if File.basename(swimming_pool_file) =~ /^__template/
        swimming_pool_data = YAML.load_file(swimming_pool_file)
        SwimmingPool.new(swimming_pool_data)
      end.compact
    )
  end
  
end