require 'net/http'
require 'fileutils'

require File.join(File.dirname(__FILE__), '..', 'config', 'environment')
require File.join(PROJECT_ROOT, 'config', 'akismet')
require 'comment'

COMMENT_SPAM_DIRECTORY = File.join(PROJECT_ROOT, 'tmp', 'comment-spam')
COMMENT_HAM_DIRECTORY = File.join(PROJECT_ROOT, 'tmp', 'comment-ham')

FileUtils.mkdir_p(COMMENT_SPAM_DIRECTORY)
FileUtils.mkdir_p(COMMENT_HAM_DIRECTORY)

comments = Comment.find(:all, :conditions => 'published = false and id > 62544')
puts "Checking #{comments.length} comments for spam content"
comments.each_with_index do |comment, index|

  puts "Checking comment #{index}" if index % 5 == 0
  
  url = URI.parse(AKISMET_COMMENT_CHECK_URL)
  begin
    response = Net::HTTP.new(url.host, url.port).start do |http|
      request_data = {
        'blog' => MY_BLOG_URL,
        'user_ip' => comment.ip,
        'comment_type' => 'comment',
        'comment_author' => comment.author,
        'comment_author_email' => comment.email,
        'comment_author_url' => comment.url,
        'comment_content' => comment.body
      }
      request = Net::HTTP::Post.new(url.path)
      request.set_form_data(request_data)
      http.request(request)
    end
  rescue Timeout::Error => e
    puts "Timed out on comment id: #{comment.id}. Retrying"
    retry
  end

  output_directory = (response.body == 'true') ? COMMENT_SPAM_DIRECTORY : COMMENT_HAM_DIRECTORY
  File.open(File.join(output_directory, "#{comment.id}.yml"), 'w') { |f| f.puts(comment.to_yaml) }
  
  sleep 0.2

end