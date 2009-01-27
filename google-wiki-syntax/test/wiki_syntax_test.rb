require 'test/unit'
require File.join(File.dirname(__FILE__), '..', 'lib', 'wiki_syntax')

module Kernel
  alias_method :__original_p, :p
  def p(*args)
    __original_p(*args)
  end
end

class WikiSyntaxHtmlEscapingTest < Test::Unit::TestCase
  
  def test_should_html_escape_wiki_content
    assert_equal "<p>this &amp; that. 1 &lt; 2. 2 &gt; 1.</p>", WikiSyntax.new('this & that. 1 < 2. 2 > 1.').to_html
  end

end

class WikiSyntaxParagraphTest < Test::Unit::TestCase

  def test_should_surround_content_on_one_line_in_one_html_paragraph_tag
    assert_equal "<p>line 1</p>", WikiSyntax.new('line 1').to_html
  end

  def test_should_surround_content_on_two_subsequent_lines_in_one_html_paragraph_tag
    assert_equal "<p>line 1 line 2</p>", WikiSyntax.new("line 1\nline 2").to_html
  end

  def test_should_surround_content_separated_by_a_new_line_in_two_html_paragraph_tags
    assert_equal "<p>line 1</p><p>line 2</p>", WikiSyntax.new("line 1\n\nline 2").to_html
  end

  def test_should_ignore_newlines_at_the_end_of_the_wiki_content
    assert_equal "<p>line 1</p>", WikiSyntax.new("line 1\n\n\n").to_html
  end

  def test_should_create_two_paragraphs_and_ignore_newlines_at_the_end_of_the_wiki_content
    assert_equal "<p>line 1</p><p>line 2</p>", WikiSyntax.new("line 1\n\n\nline 2\n\n").to_html
  end

  def test_should_create_a_paragraph_when_the_string_contains_a_block_level_html_tag
    assert_equal "<p>paragraph including an html tag: pre</p>", WikiSyntax.new("paragraph including an html tag: pre").to_html
  end

end

class WikiSyntaxTypefaceTest < Test::Unit::TestCase

  def test_should_enclose_text_in_html_italic_tags
    assert_equal "<p><i>italic</i></p>", WikiSyntax.new('_italic_').to_html
  end

  def test_should_not_enclose_text_in_html_italic_tags
    assert_equal "<p>_notitalic</p>", WikiSyntax.new('_notitalic').to_html
  end

  def test_should_enclose_text_in_html_strong_tags
    assert_equal "<p><strong>bold</strong></p>", WikiSyntax.new('*bold*').to_html
  end

  def test_should_not_enclose_text_in_html_strong_tags
    assert_equal "<p>*not_bold</p>", WikiSyntax.new('*not_bold').to_html
  end

  def test_should_enclose_text_in_html_sup_tags
    assert_equal "<p><sup>super</sup>script</p>", WikiSyntax.new('^super^script').to_html
  end

  def test_should_not_enclose_text_in_html_sup_tags
    assert_equal "<p>^not_superscript</p>", WikiSyntax.new('^not_superscript').to_html
  end

  def test_should_enclose_text_in_html_sub_tags
    assert_equal "<p><sub>sub</sub>script</p>", WikiSyntax.new(',,sub,,script').to_html
  end

  def test_should_not_enclose_text_in_html_sub_tags
    assert_equal "<p>,,not_subscript</p>", WikiSyntax.new(',,not_subscript').to_html
  end

  def test_should_enclose_text_in_html_strike_tags
    assert_equal "<p><strike>strikeout</strike></p>", WikiSyntax.new('~~strikeout~~').to_html
  end

  def test_should_not_enclose_text_in_html_strike_tags
    assert_equal "<p>~~not_strikeout</p>", WikiSyntax.new('~~not_strikeout').to_html
  end

  def test_should_enclose_strong_tags_within_italic_tags
    assert_equal "<p><i><strong>bold</strong> in italics</i></p>", WikiSyntax.new("_*bold* in italics_").to_html
  end

  def test_should_enclose_italic_tags_within_strong_tags
    assert_equal "<p><strong><i>italics</i> in bold</strong></p>", WikiSyntax.new("*_italics_ in bold*").to_html
  end

  def test_should_strike_words_within_strong_tags
    assert_equal "<p><strong><strike>strike</strike> works too</strong></p>", WikiSyntax.new("*~~strike~~ works too*").to_html
  end

  def test_should_italicise_one_of_the_striked_words
    assert_equal "<p><strike>as well as <i>this</i> way round</strike></p>", WikiSyntax.new("~~as well as _this_ way round~~").to_html
  end
  
end

class WikiSyntaxCodeTest < Test::Unit::TestCase

  def test_should_deal_with_over_10_code_blocks
    letters = %w(A B C D E F G H I J K)
    assert letters.length > 10
    wiki_content = letters.collect { |letter| "{{{ code-block-#{letter} }}}" }.join(' ')
    expected_html = letters.collect { |letter| %%<code>code-block-#{letter}</code>% }.join(' ')
    assert_equal "<p>#{expected_html}</p>", WikiSyntax.new(wiki_content).to_html
  end

  def test_should_enclose_text_in_backticks_in_html_code_tags
    assert_equal "<p><code>code</code></p>", WikiSyntax.new('`code`').to_html
  end

  def test_should_enclose_text_in_triple_braces_in_html_code_tags
    assert_equal "<p><code>code</code></p>", WikiSyntax.new('{{{code}}}').to_html
  end

  def test_should_enclose_multiline_text_in_triple_braces_in_html_pre_tags
    assert_equal "<pre>line 1\nline 2</pre>", WikiSyntax.new("{{{\nline 1\nline 2\n}}}").to_html
  end

  def test_should_not_alter_code_in_backticks
    assert_equal "<p><code>_foo = *bar</code></p>", WikiSyntax.new("`_foo = *bar`").to_html
  end

  def test_should_not_alter_code_in_triple_braces
    assert_equal "<p><code>_foo = *bar</code></p>", WikiSyntax.new("{{{_foo = *bar}}}").to_html
  end
 
  def test_should_not_alter_multiline_code_in_triple_braces
    assert_equal "<pre>_foo = *bar</pre>", WikiSyntax.new("{{{\n_foo = *bar\n}}}").to_html
  end

  def test_should_surround_two_multiline_code_blocks_with_pre_tags
    assert_equal "<pre>line1</pre><pre>line2</pre>", WikiSyntax.new("{{{\nline1\n}}}\n{{{\nline2\n}}}").to_html
  end

end

class WikiSyntaxHeadingsTest < Test::Unit::TestCase

  def test_should_generate_h1
    assert_equal "<h1>heading</h1>", WikiSyntax.new("= heading =").to_html
  end
    
  def test_should_not_generate_h1
    assert_equal '<p>= no heading</p>', WikiSyntax.new("= no heading").to_html
  end

  def test_should_generate_h2
    assert_equal "<h2>heading 2</h2>", WikiSyntax.new("== heading 2 ==").to_html
  end

  def test_should_not_generate_h2
    assert_equal '<p>== no heading</p>', WikiSyntax.new("== no heading").to_html
  end

  def test_should_generate_h3
    assert_equal "<h3>heading 3</h3>", WikiSyntax.new("=== heading 3 ===").to_html
  end

  def test_should_not_generate_h3
    assert_equal '<p>=== no heading</p>', WikiSyntax.new("=== no heading").to_html
  end

  def test_should_generate_h4
    assert_equal "<h4>heading 4</h4>", WikiSyntax.new("==== heading 4 ====").to_html
  end

  def test_should_not_generate_h4
    assert_equal '<p>==== no heading</p>', WikiSyntax.new("==== no heading").to_html
  end

  def test_should_generate_h5
    assert_equal "<h5>heading 5</h5>", WikiSyntax.new("===== heading 5 =====").to_html
  end

  def test_should_not_generate_h5
    assert_equal '<p>===== no heading</p>', WikiSyntax.new("===== no heading").to_html
  end

  def test_should_generate_h6
    assert_equal "<h6>heading 6</h6>", WikiSyntax.new("====== heading 6 ======").to_html
  end
  
  def test_should_not_generate_h6
    assert_equal '<p>====== no heading</p>', WikiSyntax.new("====== no heading").to_html
  end

end

class WikiSyntaxDividerTest < Test::Unit::TestCase
  
  def test_should_generate_horizontal_rule
    assert_equal '<hr/>', WikiSyntax.new('----').to_html
  end

  def test_should_not_generate_horizontal_rule
    assert_equal '<p>---</p>', WikiSyntax.new('---').to_html
  end

  def test_should_not_generate_horizontal_rule_when_there_is_something_other_than_dashes_on_the_line
    assert_equal '<p>hello ---- world</p>', WikiSyntax.new('hello ---- world').to_html
  end

end

class WikiSyntaxListTest < Test::Unit::TestCase
  
  def test_should_deal_with_over_10_lists
    letters = %w(A B C D E F G H I J K)
    assert letters.length > 10
    wiki_content = letters.collect { |letter| " * list-item-#{letter}" }.join("\n\n")
    expected_html = letters.collect { |letter| %%<ul><li>list-item-#{letter}</li></ul>% }.join
    assert_equal "#{expected_html}", WikiSyntax.new(wiki_content).to_html
  end

  def test_should_generate_a_one_item_ordered_list_with_no_space_between_the_hash_and_list_item
    assert_equal '<ul><li>list item</li></ul>', WikiSyntax.new(' *list item').to_html
  end

  def test_should_generate_a_one_item_unordered_list
    assert_equal '<ul><li>list item</li></ul>', WikiSyntax.new(' * list item').to_html
  end

  def test_should_generate_a_one_item_unordered_list_when_more_than_one_space_appears_at_the_beginning_of_the_line
    assert_equal '<ul><li>list item</li></ul>', WikiSyntax.new('   * list item').to_html
  end

  def test_should_generate_a_multi_item_unordered_list
    assert_equal '<ul><li>item 1</li><li>item 2</li><li>item 3</li></ul>', WikiSyntax.new(" * item 1\n * item 2\n * item 3").to_html
  end

  def test_should_generate_a_multi_item_ordered_list
    assert_equal '<ol><li>item 1</li><li>item 2</li><li>item 3</li></ol>', WikiSyntax.new(" # item 1\n # item 2\n # item 3").to_html
  end

  def test_should_generate_a_multi_level_multi_item_unordered_list
    assert_equal '<ul><li>level 1 item 1</li><ul><li>level 2 item 2</li></ul></ul>', WikiSyntax.new(" * level 1 item 1\n  * level 2 item 2").to_html
  end

  def test_should_generate_an_unordered_list_that_contains_an_ordered_list
    assert_equal '<ul><li>level 1 ul 1</li><ol><li>level 2 ol</li></ol><li>level 1 ul 2</li></ul>', WikiSyntax.new(" * level 1 ul 1\n  # level 2 ol\n * level 1 ul 2").to_html
  end

  def test_should_generate_an_ordered_list_that_contains_an_unordered_list
    assert_equal '<ol><li>ol 1</li><ul><li>ul 1</li></ul><li>ol 2</li></ol>', WikiSyntax.new(" # ol 1\n  * ul 1\n # ol 2").to_html
  end

  def test_should_generate_two_unordered_lists_separateed_by_a_paragraph
    assert_equal '<ul><li>list 1</li></ul><p>between lists</p><ul><li>list 2</li></ul>', WikiSyntax.new(" * list 1\n\nbetween lists\n\n * list 2").to_html
  end

  def test_should_allow_wiki_formatting_within_the_generated_list
    assert_equal '<ul><li><strong>bold</strong> list item</li></ul>', WikiSyntax.new(" * *bold* list item").to_html
  end

  def test_should_generate_deep_nested_list
    assert_equal '<ul><li>ul 1</li><ul><li>ul 2</li><ul><li>ul 3</li></ul></ul></ul>', WikiSyntax.new(" * ul 1\n  * ul 2\n   * ul 3").to_html
  end
  
end

class WikiSyntaxBlockQuoteTest # < Test::Unit::TestCase

  def test_should_generate_two_blockquotes_when_two_newlines_separate_the_quotes
    assert_equal '<blockquote>first</blockquote><blockquote>second</blockquote><p>no quote</p>', WikiSyntax.new(" first\n\n second\nthird").to_html
  end

  def test_should_generate_one_blockquote_when_one_newline_separates_the_quotes
    assert_equal "<blockquote>first\nsecond</blockquote><p>third</p>", WikiSyntax.new(" first\n second\nthird").to_html
  end

end

class WikiSyntaxLinkTest < Test::Unit::TestCase

  def test_should_deal_with_over_10_wiki_links
    letters = %w(A B C D E F G H I J K)
    assert letters.length > 10
    wiki_content = letters.collect { |letter| "[Link#{letter}]" }.join(' ')
    expected_html = letters.collect { |letter| %%<a href="Link#{letter}.html">Link#{letter}</a>% }.join(' ')
    assert_equal "<p>#{expected_html}</p>", WikiSyntax.new(wiki_content).to_html
  end

  def test_should_allow_wiki_words_to_be_used_in_the_description_of_wiki_links
    assert_equal '<p><a href="MyWikiWord.html">MultiWord WikiLinkDescription</a></p>', WikiSyntax.new('[MyWikiWord MultiWord WikiLinkDescription]').to_html
  end

  def test_should_generate_a_relative_link_for_a_wiki_word_that_does_not_follow_wiki_syntax
    assert_equal '<p><a href="Mylink.html">Mylink</a></p>', WikiSyntax.new('[Mylink]').to_html
    assert_equal '<p>Text with a <a href="Mylink.html">Mylink</a> in the middle</p>', WikiSyntax.new('Text with a [Mylink] in the middle').to_html
  end
  
  def test_should_add_an_html_extension_to_wiki_words
    assert_equal '<p><a href="MyLink.html">MyLink</a></p>', WikiSyntax.new('MyLink').to_html
    assert_equal '<p>Text with a <a href="MyLink.html">MyLink</a> in the middle</p>', WikiSyntax.new('Text with a MyLink in the middle').to_html
  end
  
  def test_should_generate_a_relative_link_for_a_wiki_word
    assert_equal '<p><a href="MyLink.html">MyLink</a></p>', WikiSyntax.new('MyLink').to_html
    assert_equal '<p>Text with a <a href="MyLink.html">MyLink</a> in the middle</p>', WikiSyntax.new('Text with a MyLink in the middle').to_html
  end

  def test_should_generate_a_paragraph_containing_the_escaped_wiki_word
    assert_equal '<p>MyLink</p>', WikiSyntax.new('!MyLink').to_html
    assert_equal '<p>Text with a WikiWord in the middle</p>', WikiSyntax.new('Text with a !WikiWord in the middle').to_html
  end

  def test_should_generate_a_link_to_external_http_urls
    assert_equal '<p><a href="http://www.google.com">http://www.google.com</a></p>', WikiSyntax.new('http://www.google.com').to_html
    assert_equal '<p>Click <a href="http://example.com">http://example.com</a> to visit</p>', WikiSyntax.new('Click http://example.com to visit').to_html
  end

  def test_should_generate_a_link_with_specific_anchor_text_to_external_http_urls
    assert_equal '<p><a href="http://www.google.com">google home page</a></p>', WikiSyntax.new('[http://www.google.com google home page]').to_html
    assert_equal '<p>Click <a href="http://www.google.com">google home page</a> to visit</p>', WikiSyntax.new('Click [http://www.google.com google home page] to visit').to_html
  end

  def test_should_generate_a_relative_link_with_specific_anchor_text_for_a_wiki_word
    assert_equal '<p><a href="MyLink.html">my link</a></p>', WikiSyntax.new('[MyLink my link]').to_html
    assert_equal '<p>Click <a href="MyLink.html">my link</a> to visit</p>', WikiSyntax.new('Click [MyLink my link] to visit').to_html
  end

  def test_should_generate_a_link_to_external_ftp_urls
    assert_equal '<p><a href="ftp://ftp.kernel.org">ftp://ftp.kernel.org</a></p>', WikiSyntax.new('ftp://ftp.kernel.org').to_html
    assert_equal '<p>Click <a href="ftp://ftp.kernel.org">ftp://ftp.kernel.org</a> to visit</p>', WikiSyntax.new('Click ftp://ftp.kernel.org to visit').to_html
  end

  def test_should_generate_a_link_to_external_ftp_urls
    assert_equal '<p><a href="ftp://ftp.kernel.org">kernel ftp site</a></p>', WikiSyntax.new('[ftp://ftp.kernel.org kernel ftp site]').to_html
    assert_equal '<p>Click <a href="ftp://ftp.kernel.org">kernel ftp site</a> to visit</p>', WikiSyntax.new('Click [ftp://ftp.kernel.org kernel ftp site] to visit').to_html
  end

end

class WikiSyntaxImageTest < Test::Unit::TestCase
  
  def test_should_insert_a_png_image
    assert_equal '<p><img src="http://www.example.com/image.png" /></p>', WikiSyntax.new('http://www.example.com/image.png').to_html
    assert_equal '<p>My first <img src="http://www.example.com/image.png" /> image</p>', WikiSyntax.new('My first http://www.example.com/image.png image').to_html
  end

  def test_should_insert_a_gif_image
    assert_equal '<p><img src="http://www.example.com/image.gif" /></p>', WikiSyntax.new('http://www.example.com/image.gif').to_html
    assert_equal '<p>My first <img src="http://www.example.com/image.gif" /> image</p>', WikiSyntax.new('My first http://www.example.com/image.gif image').to_html
  end

  def test_should_insert_a_jpg_image
    assert_equal '<p><img src="http://www.example.com/image.jpg" /></p>', WikiSyntax.new('http://www.example.com/image.jpg').to_html
    assert_equal '<p>My first <img src="http://www.example.com/image.jpg" /> image</p>', WikiSyntax.new('My first http://www.example.com/image.jpg image').to_html
  end

  def test_should_insert_a_jpeg_image
    assert_equal '<p><img src="http://www.example.com/image.jpeg" /></p>', WikiSyntax.new('http://www.example.com/image.jpeg').to_html
    assert_equal '<p>My first <img src="http://www.example.com/image.jpeg" /> image</p>', WikiSyntax.new('My first http://www.example.com/image.jpeg image').to_html
  end

end

class WikiSyntaxLinkedImagesTest < Test::Unit::TestCase
  
  def test_should_link_to_a_png_image
    assert_equal '<p><a href="http://www.example.com"><img src="http://www.example.com/image.png" /></a></p>', WikiSyntax.new('[http://www.example.com http://www.example.com/image.png]').to_html
    assert_equal '<p>My first <a href="http://www.example.com"><img src="http://www.example.com/image.png" /></a> image</p>', WikiSyntax.new('My first [http://www.example.com http://www.example.com/image.png] image').to_html
  end

end

class WikiSyntaxTableTest < Test::Unit::TestCase
  
  def test_should_deal_with_over_10_tables
    letters = %w(A B C D E F G H I J K)
    assert letters.length > 10
    wiki_content = letters.collect { |letter| "||table-#{letter}||" }.join("\n\n")
    expected_html = letters.collect { |letter| %%<p><table><tr><td>table-#{letter}</td></tr></table></p>% }.join
    assert_equal "#{expected_html}", WikiSyntax.new(wiki_content).to_html
  end

  def test_should_not_generate_a_table
    assert_equal "<p>|| no table here</p>", WikiSyntax.new("|| no table here").to_html
  end

  def test_should_generate_a_table_with_one_row_and_one_cell
    assert_equal "<p><table><tr><td> cell1 </td></tr></table></p>", WikiSyntax.new("|| cell1 ||").to_html
  end

  def test_should_generate_a_table_with_one_row_and_multiple_cells
    assert_equal "<p><table><tr><td> cell1 </td><td> cell2 </td><td> cell3 </td></tr></table></p>", WikiSyntax.new("|| cell1 || cell2 || cell3 ||").to_html
  end

  def test_should_generate_a_table_with_two_rows_and_one_cell
    assert_equal "<p><table><tr><td> cell1 </td></tr><tr><td> cell2 </td></tr></table></p>", WikiSyntax.new("|| cell1 ||\n|| cell2 ||").to_html
  end

  def test_should_generate_a_table_with_two_rows_and_multiple_cells
    assert_equal "<p><table><tr><td> cell1 </td><td> cell2 </td><td> cell3 </td></tr><tr><td> cell4 </td><td> cell5 </td><td> cell6 </td></tr></table></p>", WikiSyntax.new("|| cell1 || cell2 || cell3 ||\n|| cell4 || cell5 || cell6 ||").to_html
  end

  def test_should_generate_two_tables
    assert_equal "<p><table><tr><td> cell1 </td></tr></table></p><p><table><tr><td> cell2 </td></tr></table></p>", WikiSyntax.new("|| cell1 ||\n\n|| cell2 ||").to_html
  end

end

class WikiSyntaxSummaryTest < Test::Unit::TestCase
  
  def test_should_render_the_summary_in_a_paragraph
    assert_equal '<p class="summary">summary of the page</p>', WikiSyntax.new('#summary summary of the page').to_html
  end

end

class WikiSyntaxLabelsTest < Test::Unit::TestCase
  
  def test_should_render_the_labels_in_a_paragraph
    assert_equal '<p class="labels">label1, label2</p>', WikiSyntax.new('#labels label1, label2').to_html
  end

end

begin
  require 'tidy'
rescue LoadError
  warn "Skipping the next couple of tests because the tidy gem or binary wasn't found"
  exit
end

Tidy.path = '/opt/local/lib/libtidy.dylib'

class WikiSyntaxFullTest < Test::Unit::TestCase
  
  def test_should_construct_html_document
    expected_html = Tidy.new.clean(self.expected_html)
    actual_html = Tidy.new.clean(WikiSyntax.new(wiki_markup).to_html)
    assert_equal expected_html, actual_html
  end

  def wiki_markup
<<-EndWikiMarkup
#summary The document.doctype property ...
#labels about-dom,is-dom-property

== Values ==

The `document.doctype` property returns a string.

This property is read-only.

== Usage ==

== Browser compatibility ==

|| *Test* || *IE8* || *IE7* || *IE6* || *FF3* || *FF2* || *Saf3* ||
|| [http://doctype.googlecode.com/svn/trunk/tests/js/document/document-doctype-typeof-test.html typeOf(document.doctype) != 'undefined'] || Y || Y || Y || Y || Y || Y ||

== Further reading ==

  * [http://developer.mozilla.org/en/docs/DOM:document.doctype The document.doctype property on Mozilla Developer Center]
  * [http://msdn2.microsoft.com/en-us/library/ms533737.aspx The document.doctype property on MSDN]
EndWikiMarkup
  end

  def expected_html
<<EndHtml
<p class="summary">The document.doctype property ...</p>
<p class="labels">about-dom,is-dom-property</p>
<h2>Values</h2>
<p>The <code>document.doctype</code> property returns a string.</p>
<p>This property is read-only.</p>
<h2>Usage</h2>
<h2>Browser compatibility</h2>
<table>
  <tr>
    <td><strong>Test</strong></td>
    <td><strong>IE8</strong></td>
    <td><strong>IE7</strong></td>
    <td><strong>IE6</strong></td>
    <td><strong>FF3</strong></td>
    <td><strong>FF2</strong></td>
    <td><strong>Saf3</strong></td>
  </tr>
  <tr>
    <td><a href="http://doctype.googlecode.com/svn/trunk/tests/js/document/document-doctype-typeof-test.html">typeOf(document.doctype) != 'undefined'</a></td>
    <td>Y</td>
    <td>Y</td>
    <td>Y</td>
    <td>Y</td>
    <td>Y</td>
    <td>Y</td>
  </tr>
</table>
<h2>Further reading</h2>
<ul>
  <li><a href="http://developer.mozilla.org/en/docs/DOM:document.doctype">The document.doctype property on Mozilla Developer Center</a></li>
  <li><a href="http://msdn2.microsoft.com/en-us/library/ms533737.aspx">The document.doctype property on MSDN</a></li>
</ul>
EndHtml
  end

end

class WikiSyntaxToHtmlDocumentTest < Test::Unit::TestCase

  def test_should_create_a_complete_html_document
    expected_html = Tidy.new.clean(self.expected_html)
    actual_html = Tidy.new.clean(WikiSyntax.new(self.wiki_markup).to_html_document('PageTitle'))
    assert_equal expected_html, actual_html
  end

  def wiki_markup
<<EndWikiMarkup
= My Wiki Page =

Some text on my wiki page
EndWikiMarkup
  end

  def expected_html
<<EndHtml
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
  <head>
    <title>PageTitle</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  </head>
  <body>
    <h1>My Wiki Page</h1>
    <p>Some text on my wiki page</p>
  </body>
</html>
EndHtml
  end

end
