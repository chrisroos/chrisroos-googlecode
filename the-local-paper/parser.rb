require 'csv'

class PaperParser
  def self.parse(filename)
    new(filename).parse
  end
  def initialize(filename)
    File.basename(filename) =~ /^(\d{4}-\d{2}-\d{2})-(.*)\.txt$/
    @date, @title = $1, $2
  end
  def parse
    {
      :date => Date.parse(@date),
      :title => @title.gsub(/-/, ' ')
    }
  end
end

class ArticleParser
  def initialize(io)
    @io = io
  end
  def each
    @io.each do |line|
      next if line =~ /^#/
      page_number, title, author, *attributes = CSV.parse_line(line)
      attributes = attributes.inject({}) { |h, key_value| key, value = key_value.split(':'); h[key] = value; h }
      data = {
        :page_number => page_number,
        :title => title,
        :author => author,
        :attributes => attributes
      }
      yield data
    end
  end
end