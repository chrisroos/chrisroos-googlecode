require 'yaml'

class ConfigurationLoader
  RULES_PATH = File.join(File.dirname(__FILE__), 'rules')
  def initialize(request)
    host = request.params['HTTP_X_FORWARDED_HOST']
    @config_file_path = File.join(RULES_PATH, host)
  end
  def load_rules
    YAML.load(File.open(@config_file_path))
  end
end