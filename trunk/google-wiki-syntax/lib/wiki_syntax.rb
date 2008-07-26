require File.join(File.dirname(__FILE__), 'list_block')

class WikiSyntax
  ListBlockRegex = /(#{ListBlock::LineRegex}\n?)+/m # One or more list items, optionally ending with newlines
  Tokens = {
    '_' => 'i',
    '*' => 'b',
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
    @wiki_content = wiki_content
  end
  def to_html
    html = @wiki_content

    # Extract code blocks from the wiki_content so that we leave the code blocks as they are
    pres = []
    html = html.gsub(/(`|\{\{\{).*?(\}\}\}|`)/m) do |code_block|
      code_block.gsub!(/`|\{|\}/, '')
      pres << code_block 
      "PRE#{pres.length}"
    end

    # Extract list blocks so that we can parse them separately
    list_blocks = []
    html.gsub!(ListBlockRegex) do |list_block|
      list_blocks << list_block
      "LISTBLOCK#{list_blocks.length}"
    end

    list_blocks.each_with_index do |list_block, index|
      list_block = ListBlock.new(list_block)
      list_blocks[index] = list_block.to_html
    end
    
    if list_blocks.any?
      list_blocks.each_with_index do |list_block, index|
        html.gsub!(/LISTBLOCK#{index+1}/, list_block)
      end
    end

    # Tables
    tables = []
    html.gsub!(/\|\|(.*?\|\|)+(\n\|\|(.*?\|\|)+)*/) do |table|
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
      html.gsub!(/TABLE#{index+1}/, table_html)
    end

    # Wiki Words
    html.gsub!(Regex::WikiWord) do |matched_wiki_word|
      matched_wiki_word.sub($1, %%<a href="/#{$1}">#{$1}</a>%)
    end
    html.gsub!(Regex::WikiWordWithDescription) do
      %%<a href="/#{$1}">#{$2}</a>%
    end
    html.gsub!(Regex::EscapedWikiWord) do |matched_wiki_word|
      matched_wiki_word.sub("!#{$1}", $1)
    end

    # Links to Images
    html.gsub!(Regex::HyperlinkedImage) do |matched_link_and_image_url|
      %%<a href="#{$1}"><img src="#{$2}" /></a>%
    end

    # Images
    html.gsub!(Regex::ImageUrl) do |matched_image_url|
      matched_image_url.sub($1, %%<img src="#{$1}" />%)
    end

    # URLs
    html.gsub!(Regex::UrlWithDescription) do |matched_url|
      %%<a href="#{$1}">#{$2}</a>%
    end
    html.gsub!(Regex::Url) do |matched_url|
      matched_url.sub($1, %%<a href="#{$1}">#{$1}</a>%)
    end

    # Special case to deal with horizontal rules
    html = html.gsub(/^-{4,}$/, '<hr/>')

    # Headings
    html.gsub!(/======([^<>=]+?)======/) { "<h6>#{$1.strip}</h6>" }
    html.gsub!(/=====([^<>=]+?)=====/) { "<h5>#{$1.strip}</h5>" }
    html.gsub!(/====([^<>=]+?)====/) { "<h4>#{$1.strip}</h4>" }
    html.gsub!(/===([^<>=]+?)===/) { "<h3>#{$1.strip}</h3>" }
    html.gsub!(/==([^<>=]+?)==/) { "<h2>#{$1.strip}</h2>" }
    html.gsub!(/=([^<>=]+?)=/) { "<h1>#{$1.strip}</h1>" }

    # Convert wiki markup to html tags
    open_tags = []
    html = html.gsub(TokenRegexp) do |matched_token|
      html_tag = Tokens[matched_token] 
      if open_tags.include?(html_tag)
        open_tags.delete(html_tag)
        "</#{html_tag}>"
      else
        open_tags.push(html_tag)
        "<#{html_tag}>"
      end
    end

    # Delete newlines that appear at the end of the wiki content
    while html =~ /\n\Z/; html.chomp!; end

    # Re-insert the code blocks into the wiki_content
    if pres.any?
      pres.each_with_index do |pre, index|
        pre = pre =~ /\n/ ? "<pre>" + pre.strip + "</pre>" : "<code>" + pre.strip + "</code>"
        html = html.gsub(/PRE#{index+1}/, pre)
      end
    end
    # Not convinced this is important but it removes the newline between the pre blocks in <pre>..code..</pre>\n<pre>...code...</pre>
    html = html.gsub(/<\/pre>\n<pre>/m, '</pre><pre>')

    # Find the 'blocks' of text in the content, and if they arent code then wrap them in P tags
    html_blocks = html.split(/\n{2,}/m)
    html = html_blocks.map do |block| 
      if block =~ /\A<pre|h1|h2|h3|h4|h5|h6|hr\/|ul|ol>/
        block
      else
        # remove newlines within normal (non-code) blocks of text
        "<p>" + block.gsub(/\n/, ' ') + "</p>"
      end
    end.join

    html
  end
end
