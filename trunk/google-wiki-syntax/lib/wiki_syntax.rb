require File.join(File.dirname(__FILE__), 'list_block')

class WikiSyntax

  ListBlockRegex = /(#{ListBlock::LineRegex}\n?)+/m # One or more list items, optionally ending with newlines
  Tokens = {
    '`' => 'code',
    '{{{' => 'code', '}}}' => 'code',
    '^' => 'sup',
    ',,' => 'sub',
    '~~' => 'strike'
  }
  # We need to sort the tokens in descending order of length so that the most specific tokens match before the more general (i.e. === matches before == or =)
  EscapedTokens                = Tokens.keys.sort_by { |k| k.length }.reverse.collect { |token| Regexp.escape(token) }
  TokenRegexp                  = Regexp.new(EscapedTokens.join('|'))

  module Regex
    AtStartOfStringOrBeginsWithSpaces = /(?:^| +)/
    AtEndOfStringOrEndsWithSpaces     = /(?: +|$)/
    CamelCaseWord                     = /(?:[A-Z][a-z]+){2,}/
    FtpOrHttpUrl                      = /(?:f|ht)tp:\/\/.*?/
    WikiWord                          = /#{AtStartOfStringOrBeginsWithSpaces}(#{CamelCaseWord})#{AtEndOfStringOrEndsWithSpaces}/ # A WikiWord on its own. Not preceeded by exclamation mark. One uppercase followed by one or more lowercase. One or more times
    WikiWordWithDescription           = /\[(#{CamelCaseWord}) (.+?)\]/
    EscapedWikiWord                   = /#{AtStartOfStringOrBeginsWithSpaces}!(#{CamelCaseWord})#{AtEndOfStringOrEndsWithSpaces}/ # As a WikiWord but preceeded by exclamation mark.
    Url                               = /#{AtStartOfStringOrBeginsWithSpaces}(#{FtpOrHttpUrl})#{AtEndOfStringOrEndsWithSpaces}/
    UrlWithDescription                = /\[(#{FtpOrHttpUrl}) (.*?)\]/
    Image                             = /http:\/\/.*?\.(?:png|gif|jpe?g)/
    ImageUrl                          = /#{AtStartOfStringOrBeginsWithSpaces}(#{Image})#{AtEndOfStringOrEndsWithSpaces}/
    HyperlinkedImage                  = /\[(#{Regex::FtpOrHttpUrl}) (#{Image})\]/
  end
  
  def initialize(wiki_content)
    @wiki_content = @html = wiki_content
    @code_blocks = []
  end
  
  def to_html
    extract_code_blocks

    create_lists
    create_tables

    create_wiki_links
    create_image_links
    create_images
    create_url_links

    create_horizontal_rules

    create_headings

    create_italics
    create_bold_tags
    create_remaining_html

    insert_code_blocks
    remove_newlines_between_code_blocks
    remove_newlines_from_the_end_of_wiki_content

    create_paragraphs

    @html
  end

private
  
  def create_bold_tags
    @html.gsub!(/\*(.*?)\*/, '<b>' + '\1' + '</b>')
  end

  def create_italics
    @html.gsub!(/_(.*?)_/, '<i>' + '\1' + '</i>')
  end

  def extract_code_blocks
    @html.gsub!(/(`|\{\{\{).*?(\}\}\}|`)/m) do |code_block|
      code_block.gsub!(/`|\{|\}/, '')
      @code_blocks << code_block 
      "CODEBLOCK#{@code_blocks.length}"
    end
  end
  
  def insert_code_blocks
    if @code_blocks.any?
      @code_blocks.each_with_index do |code_block, index|
        code_block = code_block =~ /\n/ ? "<pre>" + code_block.strip + "</pre>" : "<code>" + code_block.strip + "</code>"
        @html.gsub!(/CODEBLOCK#{index+1}/, code_block)
      end
    end
  end
  
  def create_headings
    @html.gsub!(/======([^<>=]+?)======/) { "<h6>#{$1.strip}</h6>" }
    @html.gsub!(/=====([^<>=]+?)=====/) { "<h5>#{$1.strip}</h5>" }
    @html.gsub!(/====([^<>=]+?)====/) { "<h4>#{$1.strip}</h4>" }
    @html.gsub!(/===([^<>=]+?)===/) { "<h3>#{$1.strip}</h3>" }
    @html.gsub!(/==([^<>=]+?)==/) { "<h2>#{$1.strip}</h2>" }
    @html.gsub!(/=([^<>=]+?)=/) { "<h1>#{$1.strip}</h1>" }
  end
  
  def create_wiki_links
    @html.gsub!(Regex::WikiWord) do |matched_wiki_word|
      matched_wiki_word.sub($1, %%<a href="/#{$1}">#{$1}</a>%)
    end
    @html.gsub!(Regex::WikiWordWithDescription) do
      %%<a href="/#{$1}">#{$2}</a>%
    end
    @html.gsub!(Regex::EscapedWikiWord) do |matched_wiki_word|
      matched_wiki_word.sub("!#{$1}", $1)
    end
  end
  
  def create_url_links
    @html.gsub!(Regex::UrlWithDescription) do |matched_url|
      %%<a href="#{$1}">#{$2}</a>%
    end
    @html.gsub!(Regex::Url) do |matched_url|
      matched_url.sub($1, %%<a href="#{$1}">#{$1}</a>%)
    end
  end
  
  def create_images
    @html.gsub!(Regex::ImageUrl) do |matched_image_url|
      matched_image_url.sub($1, %%<img src="#{$1}" />%)
    end
  end
  
  def create_image_links
    @html.gsub!(Regex::HyperlinkedImage) do |matched_link_and_image_url|
      %%<a href="#{$1}"><img src="#{$2}" /></a>%
    end
  end
  
  def create_horizontal_rules
    @html.gsub!(/^-{4,}$/, '<hr/>')
  end
  
  def create_lists
    list_blocks = []
    @html.gsub!(ListBlockRegex) do |list_block|
      list_blocks << list_block
      "LISTBLOCK#{list_blocks.length}"
    end
    list_blocks.each_with_index do |list_block, index|
      list_block = ListBlock.new(list_block)
      @html.gsub!(/LISTBLOCK#{index+1}/, list_block.to_html)
    end
  end
  
  def create_tables
    tables = []
    @html.gsub!(/\|\|(.*?\|\|)+(\n\|\|(.*?\|\|)+)*/) do |table|
      tables << table
      "TABLE#{tables.length}"
    end
    tables.each_with_index do |table, index|
      table_html = ''
      table.each_line do |line|
        line = line.chomp
        line.gsub!(/\|\|(.*)\|\|/) do |match|
          "<tr><td>#{$1}</td></tr>"
        end
        line.gsub!(/\|\|/, '</td><td>')
        table_html << line
      end
      table_html = "<table>#{table_html}</table>"
      @html.gsub!(/TABLE#{index+1}/, table_html)
    end
  end
  
  def remove_newlines_from_the_end_of_wiki_content
    while @html =~ /\n\Z/; @html.chomp!; end
  end
  
  def remove_newlines_between_code_blocks
    @html.gsub!(/<\/pre>\n<pre>/m, '</pre><pre>')
  end
  
  def create_remaining_html
    open_tags = []
    @html.gsub!(TokenRegexp) do |matched_token|
      html_tag = Tokens[matched_token] 
      if open_tags.include?(html_tag)
        open_tags.delete(html_tag)
        "</#{html_tag}>"
      else
        open_tags.push(html_tag)
        "<#{html_tag}>"
      end
    end
  end
  
  def create_paragraphs
    html_blocks = @html.split(/\n{2,}/m)
    @html = html_blocks.map do |block| 
      if block =~ /\A<pre|h1|h2|h3|h4|h5|h6|hr\/|ul|ol>/
        block
      else
        # remove newlines within normal (non-code) blocks of text
        "<p>" + block.gsub(/\n/, ' ') + "</p>"
      end
    end.join
  end

end
