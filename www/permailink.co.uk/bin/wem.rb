require 'tmail'
require 'erb'

template = DATA.read
erb = ERB.new(template)

Dir[File.join(File.dirname(__FILE__), '..', 'emails', '*')].each do |raw_email_filename|
  next unless File.file?(raw_email_filename)
  id = raw_email_filename[/GmailId(.*)/, 1]
  tmail = TMail::Mail.load(raw_email_filename)
  sender = tmail.from.first
  if tmail.attachments && tmail.attachments.length == 1
    attachment = tmail.attachments.first
    tmail = TMail::Mail.parse(attachment.string)
  end
  html = erb.result(binding)
  File.open(File.join(File.dirname(__FILE__), '..', 'public', "#{id}.html"), 'w') { |f| f.puts(html) }
  File.open(File.join(File.dirname(__FILE__), '..', 'emails', 'outgoing', id), 'w') { |f| f.puts(sender) }
end

__END__
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%= tmail.subject %></title>
    <style type="text/css">
      body {
        font-family: arial,helvetica,clean,sans-serif
      }
      dl {
        font-size: smaller;
      }
      dt {
        width: 7em;
        color: #555;
      }
      dt,dd {
        display: inline;
        margin: 0;
        float: left;
      }
    </style>
  </head>
  <body>
    <h1><%= tmail.subject %></h1>
    <dl>
      <dt>Received:</dt>
      <dd><%= tmail.date %></dd>
      <br/>
      <dt>From:</dt>
      <dd><%= tmail.from.join(', ') %></dd>
      <br/>
      <dt>To:</dt>
      <dd><%= tmail.to.join(', ') %></dd>
      <br/>
    </dl>
    <hr/>
    <% if tmail.content_type == 'text/html' %>
      <%= tmail.body %>
    <% else %>
      <p><%= tmail.body.gsub(/\n/, "<br/>\n") %></p>
    <% end %>
  </body>
</html>
