require File.join(File.dirname(__FILE__), 'install_manifest')
require File.join(File.dirname(__FILE__), 'update_manifest')

EXTENSION_ROOT             = File.expand_path(File.join(File.dirname(__FILE__)))
EXTENSION_BUILD_DIRECTORY  = File.join(EXTENSION_ROOT, 'build')
EXTENSION_CONFIG_DIRECTORY = File.join(EXTENSION_ROOT, 'config')
EXTENSION_SRC_DIRECTORY    = File.join(EXTENSION_ROOT, 'src')