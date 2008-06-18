require 'fileutils'

class MoinMoinWikiPageCreator
  First = '00000001'
  def initialize(source_wiki_page, moinmoin_wiki_pages_directory, convertor)
    @source_wiki_page, @moinmoin_wiki_pages_directory, @convertor = source_wiki_page, moinmoin_wiki_pages_directory, convertor
    @page_name = File.basename(source_wiki_page, '.wiki')
  end
  def create
    delete_wiki_page_directory
    create_wiki_page_directory
    create_wiki_page_revisions_directory
    create_the_first_revision
    make_the_first_revision_current
    convert_the_wiki_content
  end
  private
  def wiki_page_directory
    File.join(@moinmoin_wiki_pages_directory, @page_name)
  end
  def wiki_page_revisions_directory
    File.join(wiki_page_directory, 'revisions')
  end
  def wiki_page_first_revision
    File.join(wiki_page_revisions_directory, First)
  end
  def delete_wiki_page_directory
    FileUtils.rm_rf(wiki_page_directory)
  end
  def create_wiki_page_directory
    FileUtils.mkdir_p(wiki_page_directory)
  end
  def create_wiki_page_revisions_directory
    FileUtils.mkdir_p(wiki_page_revisions_directory)
  end
  def create_the_first_revision
    FileUtils.cp(@source_wiki_page, wiki_page_first_revision)
  end
  def make_the_first_revision_current
    File.open(File.join(wiki_page_directory, 'current'), 'w') { |f| f.puts(First) }
  end
  def convert_the_wiki_content
    @convertor.convert(wiki_page_first_revision)
  end
end
