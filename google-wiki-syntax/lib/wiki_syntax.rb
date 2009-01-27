require File.join(File.dirname(__FILE__), 'list_block')
require 'cgi'

class WikiSyntax

  module Regex
    ListBlock                         = /(#{ListBlock::LineRegex}\n?)+/m
    AtStartOfStringOrBeginsWithSpaces = /(?:^| +)/
    AtEndOfStringOrEndsWithSpaces     = /(?: +|$)/
    CamelCaseWord                     = /(?:[A-Z][a-z]+){2,}/
    FtpOrHttpUrl                      = /(?:f|ht)tp:\/\/.*?/
    WikiWord                          = /#{AtStartOfStringOrBeginsWithSpaces}(#{CamelCaseWord})#{AtEndOfStringOrEndsWithSpaces}/ # A WikiWord on its own. Not preceeded by exclamation mark. One uppercase followed by one or more lowercase. One or more times
    WikiWordWithOptionalDescription   = /\[(.*?)(?: (.+?))?\]/
    EscapedWikiWord                   = /#{AtStartOfStringOrBeginsWithSpaces}!(#{CamelCaseWord})#{AtEndOfStringOrEndsWithSpaces}/ # As a WikiWord but preceeded by exclamation mark.
    Url                               = /#{AtStartOfStringOrBeginsWithSpaces}(#{FtpOrHttpUrl})#{AtEndOfStringOrEndsWithSpaces}/
    UrlWithDescription                = /\[(#{FtpOrHttpUrl}) (.*?)\]/
    Image                             = /http:\/\/.*?\.(?:png|gif|jpe?g)/
    ImageUrl                          = /#{AtStartOfStringOrBeginsWithSpaces}(#{Image})#{AtEndOfStringOrEndsWithSpaces}/
    HyperlinkedImage                  = /\[(#{Regex::FtpOrHttpUrl}) (#{Image})\]/
    BoldText                          = /\*(.*?)\*/
    StrikeoutText                     = /~~(.*?)~~/
    SubscriptText                     = /,,(.*?),,/
    SuperscriptText                   = /\^(.*?)\^/
    ItalicText                        = /_(.*?)_/
    CodeBlock                         = /(`|\{\{\{).*?(\}\}\}|`)/m
    HorizontalRule                    = /^-{4,}$/
    Heading6                          = /======([^<>=]+?)======/
    Heading5                          = /=====([^<>=]+?)=====/
    Heading4                          = /====([^<>=]+?)====/
    Heading3                          = /===([^<>=]+?)===/
    Heading2                          = /==([^<>=]+?)==/
    Heading1                          = /=([^<>=]+?)=/
    Table                             = /\|\|(.*?\|\|)+(\n\|\|(.*?\|\|)+)*/
    TableCell                         = /\|\|(.*)\|\|/
  end
  
  def initialize(wiki_content)
    @html = CGI.escapeHTML(wiki_content)
    @code_blocks, @wiki_links = [], []
  end
  
  def to_html_document(page_title)
<<EndHtml
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
  <head>
    <title>#{page_title}</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  </head>
  <body>
    #{to_html}
  </body>
</html>
EndHtml
  end

  def to_html
    extract_summary
    extract_labels

    extract_code_blocks

    create_lists
    create_tables

    create_image_links
    create_images
    create_url_links
    create_wiki_links

    create_horizontal_rules

    create_headings

    create_italic_tags
    create_bold_tags
    create_superscript_tags
    create_subscript_tags
    create_strike_tags

    insert_code_blocks
    remove_newlines_between_code_blocks
    remove_newlines_from_the_end_of_wiki_content

    create_paragraphs

    @html
  end

private

  def extract_labels
    @html.sub!(/^#labels (.*)$/, '<p class="labels">' + '\1' + '</p>')
  end
  
  def extract_summary
    @html.sub!(/^#summary (.*)$/, '<p class="summary">' + '\1' + '</p>')
  end
  
  def create_strike_tags
    @html.gsub!(Regex::StrikeoutText, '<strike>' + '\1' + '</strike>')
  end

  def create_subscript_tags
    @html.gsub!(Regex::SubscriptText, '<sub>' + '\1' + '</sub>')
  end

  def create_superscript_tags
    @html.gsub!(Regex::SuperscriptText, '<sup>' + '\1' + '</sup>')
  end

  def create_bold_tags
    @html.gsub!(Regex::BoldText, '<strong>' + '\1' + '</strong>')
  end

  def create_italic_tags
    @html.gsub!(Regex::ItalicText, '<i>' + '\1' + '</i>')
  end

  def extract_code_blocks
    @html.gsub!(Regex::CodeBlock) do |code_block|
      code_block.gsub!(/`|\{|\}/, '')
      @code_blocks << code_block 
      "CODEBLOCK#{@code_blocks.length}"
    end
  end
  
  def insert_code_blocks
    @html.gsub!(/CODEBLOCK(\d+)/) do
      code_block = @code_blocks[Integer($1)-1]
      code_block =~ /\n/ ? "<pre>" + code_block.strip + "</pre>" : "<code>" + code_block.strip + "</code>"
    end
  end
  
  def create_headings
    @html.gsub!(Regex::Heading6) { "<h6>#{$1.strip}</h6>" }
    @html.gsub!(Regex::Heading5) { "<h5>#{$1.strip}</h5>" }
    @html.gsub!(Regex::Heading4) { "<h4>#{$1.strip}</h4>" }
    @html.gsub!(Regex::Heading3) { "<h3>#{$1.strip}</h3>" }
    @html.gsub!(Regex::Heading2) { "<h2>#{$1.strip}</h2>" }
    @html.gsub!(Regex::Heading1) { "<h1>#{$1.strip}</h1>" }
  end
  
  def extract_wiki_links
    @html.gsub!(Regex::WikiWordWithOptionalDescription) do
      link_text = $2 ? $2 : $1
      @wiki_links << %%<a href="#{$1}.html">#{link_text}</a>%
      "WIKILINK#{@wiki_links.length}"
    end
  end

  def insert_wiki_links
    @html.gsub!(/WIKILINK(\d+)/) do
      @wiki_links[Integer($1)-1]
    end
  end
   
  def create_wiki_links
    extract_wiki_links
    @html.gsub!(Regex::WikiWord) do |matched_wiki_word|
      matched_wiki_word.sub($1, %%<a href="#{$1}.html">#{$1}</a>%)
    end
    insert_wiki_links
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
    @html.gsub!(Regex::HorizontalRule, '<hr/>')
  end
  
  def create_lists
    @html.gsub!(Regex::ListBlock) do |list_block|
      ListBlock.new(list_block).to_html
    end
  end
  
  def create_tables
    @html.gsub!(Regex::Table) do |table|
      table_html = ''
      table.each_line do |line|
        line = line.chomp
        line.gsub!(Regex::TableCell) do |match|
          "<tr><td>#{$1}</td></tr>"
        end
        line.gsub!(/\|\|/, '</td><td>')
        table_html << line
      end
      "<table>#{table_html}</table>"
    end
  end
  
  def remove_newlines_from_the_end_of_wiki_content
    while @html =~ /\n\Z/; @html.chomp!; end
  end
  
  def remove_newlines_between_code_blocks
    @html.gsub!(/<\/pre>\n<pre>/m, '</pre><pre>')
  end
  
  def create_paragraphs
    html_blocks = @html.split(/\n{2,}/m)
    @html = html_blocks.map do |block| 
      if block =~ /\A<(p|pre|h1|h2|h3|h4|h5|h6|hr\/|ul|ol)/
        block
      else
        # remove newlines within normal (non-code) blocks of text
        "<p>" + block.gsub(/\n/, ' ') + "</p>"
      end
    end.join
  end

end
