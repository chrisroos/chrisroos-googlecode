require 'rubygems'
require 'builder'
require 'yaml'

config = YAML.load_file(File.join(File.dirname(__FILE__), *%w[.. config extension.yml]))
extension = config[:extension]
target_application = config[:target_application]

# UPDATE.RDF (THIS SHOULD BE NAMESPACED CONSISTENTLY WITH INSTALL.RDF GENERATION)

update_rdf_buffer = StringIO.new

builder = Builder::XmlMarkup.new(:target=>update_rdf_buffer, :indent=>2)
builder.instruct!
builder.r(:RDF, 'xmlns:r' => 'http://www.w3.org/1999/02/22-rdf-syntax-ns#', 'xmlns' => 'http://www.mozilla.org/2004/em-rdf#') do
  builder.r(:Description, :about => "urn:mozilla:extension:#{extension[:id]}") do
    builder.updates do
      builder.r(:Seq) do 
        builder.r(:li) do
          builder.r(:Description) do
            builder.version(extension[:version])
            builder.targetApplication do
              builder.r(:Description) do
                builder.id(target_application[:id])
                builder.minVersion(target_application[:min_version])
                builder.maxVersion(target_application[:max_version])
                builder.updateLink(extension[:install_url])
              end
            end
          end
        end
      end
    end
  end
end

update_rdf_file = File.join(File.dirname(__FILE__), *%w[.. public update.rdf])
File.open(update_rdf_file, 'w') { |f| f.puts(update_rdf_buffer.string) }