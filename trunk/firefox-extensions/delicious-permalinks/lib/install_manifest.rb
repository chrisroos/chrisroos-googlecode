require 'rubygems'
require 'builder'
require 'yaml'

module FirefoxExtension
  class InstallManifest
    def self.generate(configuration, output_directory, include_update_url = false)
      install_rdf_buffer = StringIO.new

      builder = Builder::XmlMarkup.new(:target=>install_rdf_buffer, :indent=>2)
      builder.instruct!
      builder.RDF(:xmlns => 'http://www.w3.org/1999/02/22-rdf-syntax-ns#', 'xmlns:em' => 'http://www.mozilla.org/2004/em-rdf#') do
        builder.Description(:about => 'urn:mozilla:install-manifest') do
          builder.em(:id, configuration[:extension][:id])
          builder.em(:name, configuration[:extension][:name])
          builder.em(:version, configuration[:extension][:version])
          builder.em(:creator, configuration[:extension][:creator])
          builder.em(:description, configuration[:extension][:description])
          builder.em(:updateURL, configuration[:extension][:update_url]) if include_update_url
          builder.em(:targetApplication) do
            builder.Description do
              builder.em(:id, configuration[:target_application][:id])
              builder.em(:minVersion, configuration[:target_application][:min_version])
              builder.em(:maxVersion, configuration[:target_application][:max_version])
            end
          end
        end
      end

      install_rdf_file = File.join(output_directory, 'install.rdf')
      File.open(install_rdf_file, 'w') { |f| f.puts(install_rdf_buffer.string) }
    end
  end
end