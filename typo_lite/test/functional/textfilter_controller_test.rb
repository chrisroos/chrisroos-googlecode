require File.dirname(__FILE__) + '/../test_helper'
require 'textfilter_controller'

require 'flickr_mock'

# Re-raise errors caught by the controller.
class TextfilterController; def rescue_action(e) raise e end; end
class ActionController::Base; def rescue_action(e) raise e end; end

class TextfilterControllerTest < Test::Unit::TestCase
  fixtures :text_filters

  def setup
    @controller = TextfilterController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @controller.request = @request
    @controller.response = @response
    @controller.assigns ||= []
    reset_whiteboard

    get :test_action # set up @url; In Rails 1.0, we can't do url_for without it.

#    @controller.initialize_current_url #rescue nil
  end

  def filter_text(text, filters, filterparams={}, filter_html=false)
    TextFilter.filter_text(text, @controller, self, filters, filterparams, filter_html)
  end

  def whiteboard
    @whiteboard ||= Hash.new
  end

  def reset_whiteboard
    @whiteboard = nil
  end

  def sparklines_available
    begin
      Plugins::Textfilters::SparklineController
    rescue NameError
      false
    end
  end

  def test_unknown
    text = filter_text('*foo*',[:unknowndoesnotexist])
    assert_equal '*foo*', text
  end

  def test_filterchain
    assert_equal '<p>foo</p>',
      filter_text('<p>foo</p>',[],{},false)

    assert_equal '&lt;p&gt;foo&lt;/p&gt;',
      filter_text('<p>foo</p>',[],{},true)
  end

  def test_code
    assert_equal %{<div class="typocode"><pre><code class="typocode_default "><notextile>foo-code</notextile></code></pre></div>},
      filter_text('<typo:code>foo-code</typo:code>',[:macropre,:macropost])

    assert_equal %{<div class="typocode"><pre><code class="typocode_ruby "><notextile><span class="ident">foo</span><span class="punct">-</span><span class="ident">code</span></notextile></code></pre></div>},
      filter_text('<typo:code lang="ruby">foo-code</typo:code>',[:macropre,:macropost])

    assert_equal %{<div class="typocode"><pre><code class="typocode_ruby "><notextile><span class="ident">foo</span><span class="punct">-</span><span class="ident">code</span></notextile></code></pre></div> blah blah <div class="typocode"><pre><code class="typocode_xml "><notextile>zzz</notextile></code></pre></div>},
      filter_text('<typo:code lang="ruby">foo-code</typo:code> blah blah <typo:code lang="xml">zzz</typo:code>',[:macropre,:macropost])
  end

  def test_code_multiline
    assert_equal %{\n<div class="typocode"><pre><code class="typocode_ruby "><notextile><span class="keyword">class </span><span class="class">Foo</span>\n  <span class="keyword">def </span><span class="method">bar</span>\n    <span class="attribute">@a</span> <span class="punct">=</span> <span class="punct">&quot;</span><span class="string">zzz</span><span class="punct">&quot;</span>\n  <span class="keyword">end</span>\n<span class="keyword">end</span></notextile></code></pre></div>\n},
      filter_text(%{
<typo:code lang="ruby">
class Foo
  def bar
    @a = "zzz"
  end
end
</typo:code>
},[:macropre,:macropost])
  end

  def test_code_plus_markup_chain
    text = <<-EOF
*header text here*

<typo:code lang="ruby">
class test
  def method
    "foo"
  end
end
</typo:code>

_footer text here_

EOF

    expects_textile = <<-EOF
<p><strong>header text here</strong></p>


<div class="typocode"><pre><code class="typocode_ruby "><span class="keyword">class </span><span class="class">test</span>
  <span class="keyword">def </span><span class="method">method</span>
    <span class="punct">&quot;</span><span class="string">foo</span><span class="punct">&quot;</span>
  <span class="keyword">end</span>
<span class="keyword">end</span></code></pre></div>

\t<p><em>footer text here</em></p>
EOF

    assert_equal expects_textile.strip, TextFilter.filter_text_by_name(text, @controller, 'textile')
  end

end
