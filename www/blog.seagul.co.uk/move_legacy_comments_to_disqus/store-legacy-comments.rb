# This little script will extract all my legacy comments from the content/articles/*.yml representation of articles and store them in individual files in the format required for them to be uploaded to disqus, including the thread_id that they must be associated with.  The thread_id comes from the list of threads that can be downloaded by using the download-disqus-threads.rb script.

require File.join(File.dirname(__FILE__), 'disqus')

gem 'RedCloth', '3.0.4' # I'm not sure why, but 4.x versions of RedCloth result in my typo_code being html escaped
require 'redcloth'

disqus_threads = YAML.load(File.read(THREADS_FILE))
comment_count  = 0

Dir[File.join(PROJECT_ROOT, 'content', 'articles', '*.yml')].each do |post_filename|
  post = YAML.load(File.read(post_filename))

  if post[:comments] && post[:comments].any?
    post_title = File.basename(post_filename, '.yml')
    
    disqus_thread = disqus_threads.find { |thread| thread['url'] == "http://chrisroos.co.uk/blog/#{post_title}" }
    raise "whoah, we didn't find the relevant disqus thread!" unless disqus_thread
    
    post[:comments].each do |comment|
      
      comment.delete(:article_id)
      comment[:thread_id] = disqus_thread['id']
      comment[:message] = RedCloth.new(comment.delete(:body)).to_html(:textile).to_s
      comment[:author_name] = comment.delete(:author)
      comment[:author_email] = if comment[:author_name] == 'Chris Roos'
        'chris@seagul.co.uk'
      else
        "#{comment[:author_name].downcase.gsub(/\W/, '')}+#{Time.now.to_i}@seagul.co.uk"
      end
      comment[:created_at] = comment.delete(:published_at).strftime("%Y-%m-%dT%H:%M")
      comment[:author_url] = comment.delete(:url)
      
      File.open(File.join(COMMENTS_DIR, "#{format('%03d', comment_count)}.txt"), 'w') { |f| f.puts(comment.to_yaml) }
      comment_count += 1
      
    end
  end
end