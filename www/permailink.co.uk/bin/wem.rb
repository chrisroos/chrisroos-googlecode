require 'tmail'
require 'erb'

template = DATA.read
erb = ERB.new(template)

Dir[File.join(File.dirname(__FILE__), '..', 'emails', '*')].each do |raw_email_filename|
  id = raw_email_filename[/GmailId(.*)/, 1]
  tmail = TMail::Mail.load(raw_email_filename)
  tmail.attachments.each do |attachment|
    tmail = TMail::Mail.parse(attachment.string)
    html = erb.result(binding)
    File.open(File.join(File.dirname(__FILE__), '..', 'public', "#{id}.html"), 'w') { |f| f.puts(html) }
  end
end

__END__
<html>
<head>
<title><%= tmail.subject %></title>
</head>
<body>
<h1><%= tmail.subject %></h1>
<dl>
<dt>Received</dt>
<dd><%= tmail.date %></dd>
<dt>From</dt>
<dd><%= tmail.from.join(', ') %></dd>
<dt>To</dt>
<dd><%= tmail.to.join(', ') %></dd>
</dl>
<p><%= tmail.body.gsub(/\n/, "<br/>\n") %></p>
</body>
</html>
