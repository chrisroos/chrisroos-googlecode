require File.join(File.dirname(__FILE__), 'lib', 'delicious')

run Proc.new { |env| 
  bookmark = Delicious::Bookmark.from_email(env['rack.input'].read)
  if bookmark.save
    [ 200, {"Content-Type" => "text/plain"}, 'success' ]
  else
    [ 400, {"Content-Type" => "text/plain"}, 'failure' ]
  end
}