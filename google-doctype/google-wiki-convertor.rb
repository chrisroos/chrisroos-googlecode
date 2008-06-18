class GoogleWikiConvertor
  def convert(google_wiki_file)
    wiki = File.read(google_wiki_file)
    labels = wiki[/^#labels (.*)/, 1]
    # p labels
    wiki = wiki.gsub(/^#labels (.*)/, '') # Delete the labels comment
    wiki = wiki.sub(/#summary (.*)/, 'Summary: \'\'\1\'\'') # Make the summary visible and make it italic so that it stands out a little
    wiki = wiki.gsub(/\[(.*?) (.*?)\]/, '[[\1|\2]]') # Convert the google wiki hyperlinks to MoinMoin wiki hyperlinks
    File.open(google_wiki_file, 'w') { |f| f.puts(wiki) }
  end
end

__END__
# Some crappy manual tests to get the regex right
wiki = DATA.read
wiki = wiki.sub(/#summary (.*)/, '_\1_' + "\n") # Make the summary visible and make it italic so that it stands out a little
wiki = wiki.gsub(/\[(.*?) (.*?)\]/, '[[\1|\2]]')
puts wiki
__END__
#summary The document.createElement method ...
#labels about-dom,is-dom-method

== Arguments ==

== Usage ==

== Browser compatibility ==

|| *Test* || *IE8* || *IE7* || *IE6* || *FF3* || *FF2* || *Saf3* ||
|| [http://doctype.googlecode.com/svn/trunk/tests/js/document/document-createElement-typeof-test.html typeOf(document.createElement) != 'undefined'] || Y || Y || Y || Y || Y || Y ||

== Further reading ==

* [http://developer.mozilla.org/en/docs/DOM:document.createElement The document.createElement method on Mozilla Developer Center]
* [http://msdn2.microsoft.com/en-us/library/ms536389.aspx The document.createElement method on MSDN]

