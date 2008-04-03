module ArticlesHelper

  def render_errors(obj)
    return "" unless obj
    tag = String.new

    unless obj.errors.empty?
      tag << %{<ul class="objerrors">}

      obj.errors.each_full do |message|
        tag << "<li>#{message}</li>"
      end

      tag << "</ul>"
    end

    tag
  end

  def page_title
    if @page_title
      # this is where the page title prefix (string) should go
      this_blog.blog_name + ' : ' + @page_title
    else
      this_blog.blog_name || "Typo"
    end
  end

  def page_header
    page_header_includes = contents.collect { |c| c.whiteboard }.collect { |w| w.select {|k,v| k =~ /^page_header_/}.collect {|(k,v)| v} }.flatten.uniq
    (
    <<-HTML
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
  <link rel="EditURI" type="application/rsd+xml" title="RSD" href="#{ server_url_for :controller => 'xml', :action => 'rsd' }" />
  <link rel="alternate" type="application/rss+xml" title="RSS" href="http://feeds.feedburner.com/DeferredUntilInspirationHits" />
  #{ javascript_include_tag "cookies" }
  #{ javascript_include_tag "prototype" }
  #{ javascript_include_tag "effects" }
  #{ javascript_include_tag "typo" }
  #{ page_header_includes.join("\n") }
  <script type="text/javascript">#{ @content_for_script }</script>
    HTML
    ).chomp
  end

  def article_links(article)
    returning code = [] do
      code << tag_links(article)        unless article.tags.empty?
      code << comments_link(article)    if article.allow_comments?
      code << trackbacks_link(article)  if article.allow_pings?
    end.join("&nbsp;<strong>|</strong>&nbsp;")
  end

  def tag_links(article)
    "Tags " + article.tags.collect { |tag| link_to tag.display_name,
      { :controller => "/articles", :action => "tag", :id => tag.name },
      :rel => "tag"
    }.sort.join(", ")
  end

  def author_link(article)
    if article.user and article.user.name.to_s.size>0
      h article.user.name
    else
      h article.author
    end
  end

  def next_link(article)
    n = article.next
    return  n ? article_link("#{n.title} &raquo;", n) : ''
  end

  def prev_link(article)
    p = article.previous
    return p ? article_link("&laquo; #{p.title}", p) : ''
  end
  
  # Generate the image tag for a commenters gravatar based on their email address
  # Valid options are described at http://www.gravatar.com/implement.php
  def gravatar_tag(email, options={})
    options.update(:gravatar_id => Digest::MD5.hexdigest(email.strip))
    options[:default] = CGI::escape(options[:default]) if options.include?(:default)
    options[:size] ||= 60

    image_tag("http://www.gravatar.com/avatar.php?" <<
      options.map { |key,value| "#{key}=#{value}" }.sort.join("&"), :class => "gravatar")
  end

  def calc_distributed_class(articles, max_articles, grp_class, min_class, max_class)
    (grp_class.to_prefix rescue grp_class.to_s) +
      ((max_articles == 0) ?
           min_class.to_s :
         (min_class + ((max_class-min_class) * articles.to_f / max_articles).to_i).to_s)
  end

  def link_to_grouping(grp)
    link_to( grp.display_name, urlspec_for_grouping(grp),
             :rel => "tag", :title => title_for_grouping(grp) )
  end

  def urlspec_for_grouping(grouping)
    { :controller => "/articles", :action => grouping.class.to_prefix, :id => grouping.permalink }
  end

  def title_for_grouping(grouping)
    "#{pluralize(grouping.article_counter, 'post')} with #{grouping.class.to_s.underscore} '#{grouping.display_name}'"
  end

  def ul_tag_for(grouping_class)
    case
    when grouping_class == Tag
      %{<ul id="taglist" class="tags">}
    else
      '<ul>'
    end
  end
end