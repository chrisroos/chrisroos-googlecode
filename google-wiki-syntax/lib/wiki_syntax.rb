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
    '~~' => 'strike',
    '= ' => 'h1', ' =' => 'h1',
    '== ' => 'h2', ' ==' => 'h2',
    '=== ' => 'h3', ' ===' => 'h3',
    '==== ' => 'h4', ' ====' => 'h4',
    '===== ' => 'h5', ' =====' => 'h5',
    '====== ' => 'h6', ' ======' => 'h6',
  }
  # We need to sort the tokens in descending order of length so that the most specific tokens match before the more general (i.e. === matches before == or =)
  EscapedTokens                = Tokens.keys.sort_by { |k| k.length }.reverse.collect { |token| Regexp.escape(token) }
  TokenRegexp                  = Regexp.new(EscapedTokens.join('|'))
  WikiWordRegex                = /(?:^| +)((?:[A-Z][a-z]+){2,})(?: +|$)/ # A WikiWord on its own. Not preceeded by exclamation mark. One uppercase followed by one or more lowercase. One or more times
  WikiWordWithDescriptionRegex = /\[((?:[A-Z][a-z]+){2,}) (.+?)\]/
  EscapedWikiWordRegex         = /(?:^| +)!((?:[A-Z][a-z]+){2,})(?: +|$)/ # As a WikiWord but preceeded by exclamation mark.
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
    
    # Wiki Words
    html.gsub!(WikiWordRegex) do |matched_wiki_word|
      matched_wiki_word.sub($1, %%<a href="/#{$1}">#{$1}</a>%)
    end
    html.gsub!(WikiWordWithDescriptionRegex) do
      %%<a href="/#{$1}">#{$2}</a>%
    end
    html.gsub!(EscapedWikiWordRegex) do |matched_wiki_word|
      matched_wiki_word.sub("!#{$1}", $1)
    end

    # Images
    html.gsub!(/(?:^| +)(http:\/\/.*?\.(?:png|gif|jpe?g))(?: |$)/) do |matched_image_url|
      matched_image_url.sub($1, %%<img src="#{$1}" />%)
    end

    # URLs
    html.gsub!(/\[((?:f|ht)tp:\/\/.*?) (.*?)\]/) do |matched_url|
      %%<a href="#{$1}">#{$2}</a>%
    end
    html.gsub!(/(?:^| +)((?:f|ht)tp:\/\/.*?)(?: |$)/) do |matched_url|
      matched_url.sub($1, %%<a href="#{$1}">#{$1}</a>%)
    end

    # Special case to deal with horizontal rules
    html = html.gsub(/^-{4,}$/, '<hr/>')

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
