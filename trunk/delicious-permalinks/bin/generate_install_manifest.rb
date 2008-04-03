require 'builder'
require 'yaml'

config = YAML.load_file(File.join(File.dirname(__FILE__), *%w[.. config extension.yml]))
extension = config[:extension]
target_application = config[:target_application]

# INSTALL.RDF

install_rdf_buffer = StringIO.new

builder = Builder::XmlMarkup.new(:target=>install_rdf_buffer, :indent=>2)
builder.instruct!
builder.RDF(:xmlns => 'http://www.w3.org/1999/02/22-rdf-syntax-ns#', 'xmlns:em' => 'http://www.mozilla.org/2004/em-rdf#') do
  builder.Description(:about => 'urn:mozilla:install-manifest') do
    builder.em(:id, extension[:id])
    builder.em(:name, extension[:name])
    builder.em(:version, extension[:version])
    builder.em(:creator, extension[:creator])
    builder.em(:description, extension[:description])
    builder.em(:updateURL, extension[:update_url])
    builder.em(:targetApplication) do
      builder.Description do
        builder.em(:id, target_application[:id])
        builder.em(:minVersion, target_application[:min_version])
        builder.em(:maxVersion, target_application[:max_version])
      end
    end
  end
end

File.open('install.rdf', 'w') { |f| f.puts(install_rdf_buffer.string) }