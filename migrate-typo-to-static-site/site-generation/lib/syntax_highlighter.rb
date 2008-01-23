require 'syntax/convertors/html'

class SyntaxHighlighter
  def self.markup_code(code, lang)
    lang = 'default' unless lang
    code = code.to_s.gsub(/\r/,'').gsub(/\A\n/,'').chomp

    convertor = Syntax::Convertors::HTML.for_syntax lang
    code = convertor.convert(code)
    code.gsub!(/<pre>/,"<pre><code class=\"typocode_#{lang}\"><notextile>")
    code.gsub!(/<\/pre>/,"</notextile></code></pre>")

    "<div class=\"typocode\">#{code}</div>"
  end
end