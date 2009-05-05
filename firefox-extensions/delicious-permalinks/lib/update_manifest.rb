require 'rubygems'
require 'builder'
require 'yaml'

class UpdateManifest
  def self.generate(configuration, output_directory)
    buffer = StringIO.new

    builder = Builder::XmlMarkup.new(:target=>buffer, :indent=>2)
    builder.instruct!
    builder.r(:RDF, 'xmlns:r' => 'http://www.w3.org/1999/02/22-rdf-syntax-ns#', :xmlns => 'http://www.mozilla.org/2004/em-rdf#') do
      builder.r(:Description, :about => "urn:mozilla:extension:#{configuration[:extension][:id]}") do
        builder.updates do
          builder.r(:Seq) do
            builder.r(:li) do
              builder.r(:Description) do
                builder.version(configuration[:extension][:version])
                builder.targetApplication do
                  builder.r(:Description) do
                    builder.id(configuration[:target_application][:id])
                    builder.minVersion(configuration[:target_application][:min_version])
                    builder.maxVersion(configuration[:target_application][:max_version])
                    builder.updateLink(configuration[:extension][:install_url])
                  end
                end
              end
            end
          end
        end
      end
    end

    output_file = File.join(output_directory, 'update.rdf')
    File.open(output_file, 'w') { |f| f.puts(buffer.string) }
  end
end