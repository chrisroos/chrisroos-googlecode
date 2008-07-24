class ListBlock
  Tokens = {
    '*' => 'ul',
    '#' => 'ol'
  }
  def initialize(wiki_content)
    @wiki_content = wiki_content
    @html, @open_tags = '', []
    @previous_indentation_to_token = @indentation_to_token = 0
  end
  def to_html
    process unless processed?
    @html
  end
  def process
    @wiki_content.each do |line|
      line =~ /^( +)(\*|#) (.*)$/ # Any number of spaces then a list token, a space and the list content
      @indentation_to_token, token, list_item_content = $1.length, $2, $3
      list_tag = Tokens[token]
      if opening_list?
        open_tag!('li') if opening_nested_list? # Opens the containing list item (li tag)
        open_tag!(list_tag)
      elsif closing_list?
        close_tag!
        close_tag! if nested_list? # Closes the containing list item (li tag)
      end
      add_list_item! list_item_content
      update_previous_indentation_to_token!
    end
    close_all_remaining_tags!
  end
private
  def opening_list?
    @indentation_to_token > @previous_indentation_to_token
  end
  def closing_list?
    @indentation_to_token < @previous_indentation_to_token
  end
  def update_previous_indentation_to_token!
    @previous_indentation_to_token = @indentation_to_token
  end
  def add_list_item!(content)
    open_tag!('li')
    add_html content
    close_tag!
  end
  def open_tag!(tag)
    add_html open_html_tag(tag)
    @open_tags.push(tag)
  end
  def close_tag!
    closing_tag = @open_tags.pop
    add_html close_html_tag(closing_tag)
  end
  def close_all_remaining_tags!
    close_tag! until @open_tags.empty?
  end
  def opening_nested_list?
    @open_tags.any?
  end
  def nested_list?
    @open_tags.last == 'li'
  end
  def processed?
    !@html.empty?
  end
  def add_html(content)
    @html << content
  end
  def open_html_tag(tag)
    "<#{tag}>"
  end
  def close_html_tag(tag)
    "</#{tag}>"
  end
end

class WikiSyntax
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
  EscapedTokens = Tokens.keys.sort_by { |k| k.length }.reverse.collect { |token| Regexp.escape(token) }
  TokenRegexp = Regexp.new(EscapedTokens.join('|'))
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
    html.gsub!(/(^ +(\*|#) .*?\n?)+/m) do |list_block|
      list_blocks << list_block
      "LISTBLOCK#{list_blocks.length}"
    end

    list_blocks.each_with_index do |list_block, index|
#      previous_indentation_to_token, list_block_buffer, open_tags = 0, '', []
#      list_block.each do |line|
#        line =~ /^( +)(\*|#) (.*)$/ # Any number of spaces then either list token, a space and the list content
#        indentation_to_token, token, list_item_content = $1.length, $2, $3
#        list_tag = ListTokens[token]
#        if indentation_to_token > previous_indentation_to_token
#          # Open a new list (and possibly list item) tag
#          if open_tags.any?
#            list_block_buffer << "<li>"
#            open_tags.push('li')
#          end
#          list_block_buffer << "<#{list_tag}>"
#          open_tags.push(list_tag)
#        elsif indentation_to_token < previous_indentation_to_token
#          # Close a list (and possibly list item) tag
#          closing_tag = open_tags.pop
#          list_block_buffer << "</#{closing_tag}>"
#          if open_tags.last == 'li'
#            open_tags.pop
#            list_block_buffer << "</li>"
#          end
#        end
#        list_block_buffer << "<li>#{list_item_content}</li>"
#        previous_indentation_to_token = indentation_to_token
#      end
#      # Pop any remaining tags off the stack
#      while open_tags.any? do
#        closing_tag = open_tags.pop
#        list_block_buffer << "</#{closing_tag}>"
#      end
      list_block = ListBlock.new(list_block)
      list_blocks[index] = list_block.to_html
    end
    
    if list_blocks.any?
      list_blocks.each_with_index do |list_block, index|
        html.gsub!(/LISTBLOCK#{index+1}/, list_block)
      end
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
