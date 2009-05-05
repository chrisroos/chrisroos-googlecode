require 'rubygems'
require 'builder'
require 'yaml'

require File.join(File.dirname(__FILE__), 'lib', 'install_manifest')
require File.join(File.dirname(__FILE__), 'lib', 'update_manifest')

module FirefoxExtension
  EXTENSION_ROOT             = File.expand_path(File.join(File.dirname(__FILE__)))
  EXTENSION_BUILD_DIRECTORY  = File.join(EXTENSION_ROOT, 'build')
  EXTENSION_CONFIG_DIRECTORY = File.join(EXTENSION_ROOT, 'config')
  EXTENSION_SRC_DIRECTORY    = File.join(EXTENSION_ROOT, 'src')
end