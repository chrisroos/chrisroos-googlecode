require 'syntax/convertors/html'

class SyntaxHighlighter
  def self.markup_code(code = '', lang = 'default')
    cssclass = nil
    linenumber = nil
    title = nil

    code = code.to_s.gsub(/\r/,'').gsub(/\A\n/,'').chomp

    convertor = Syntax::Convertors::HTML.for_syntax lang
    code = convertor.convert(code)
    code.gsub!(/<pre>/,"<pre><code class=\"typocode_#{lang} #{cssclass}\"><notextile>")
    code.gsub!(/<\/pre>/,"</notextile></code></pre>")

    if(linenumber)
      lines = code.split(/\n/).size
      linenumbers = (1..lines).to_a.collect{|line| line.to_s}.join("\n")

      code = "<table class=\"typocode_linenumber\"><tr><td class=\"lineno\">\n<pre>\n#{linenumbers}\n</pre>\n</td><td width=\"100%\">#{code}</td></tr></table>"
    end

    if(title)
      titlecode="<div class=\"codetitle\">#{title}</div>"
    else
      titlecode=''
    end

    "<div class=\"typocode\">#{titlecode}#{code}</div>"
  end
end