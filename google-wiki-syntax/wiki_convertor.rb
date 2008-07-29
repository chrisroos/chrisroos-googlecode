#! /usr/bin/env ruby

require 'lib/wiki_syntax.rb'

module GoogleWiki
  class WikiFolder
    def initialize(directory)
      @directory = directory
    end
    def each
      Dir[File.join(@directory, '*.wiki')].each do |wiki_file|
        yield WikiDocument.new(wiki_file)
      end
    end
  end

  class WikiDocument
    attr_reader :filename
    def initialize(filename)
      @filename = filename
      @document_name = File.basename(@filename, '.wiki')
    end
    def to_html_document(html_folder)
      wiki_markup = File.read(@filename)
      html = WikiSyntax.new(wiki_markup).to_html_document(@document_name)
      File.open(File.join(html_folder, "#{@document_name}.html"), 'w') { |f| f.puts(html) }
    end
  end
end

wiki_file_or_folder = ARGV.shift
html_folder = ARGV.shift
unless wiki_file_or_folder and html_folder
  puts "Usage: wiki_convertor.rb <wiki_folder or wiki_file> <html_folder>"
  exit
end

if File.directory?(wiki_file_or_folder)
  GoogleWiki::WikiFolder.new(wiki_file_or_folder).each do |wiki_document|
    puts "Converting #{wiki_document.filename}..."
    wiki_document.to_html_document(html_folder)
  end
else
  GoogleWiki::WikiDocument.new(wiki_file_or_folder).to_html_document(html_folder)
end
