class ListBlock
  LineRegex = /^( +)(\*|#)(.*)$/ # Any number of spaces then a list token, a space and the list content
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
      extract_variables_from_line!(line)
      open_tag!(list_tag) if opening_list?
      close_tag! if closing_list?
      add_list_item!
      update_previous_indentation_to_token!
    end
    close_all_remaining_tags!
    add_newline_for_succeeding_paragraphs!
  end
private
  def add_newline_for_succeeding_paragraphs!
    @html << "\n"
  end
  def extract_variables_from_line!(line)
    line =~ LineRegex
    @indentation_to_token, @token, @list_item_content = $1.length, $2, $3.strip
  end
  def list_tag
    Tokens[@token]
  end
  def opening_list?
    @indentation_to_token > @previous_indentation_to_token
  end
  def closing_list?
    @indentation_to_token < @previous_indentation_to_token
  end
  def update_previous_indentation_to_token!
    @previous_indentation_to_token = @indentation_to_token
  end
  def add_list_item!
    open_tag!('li')
    add_html @list_item_content
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
