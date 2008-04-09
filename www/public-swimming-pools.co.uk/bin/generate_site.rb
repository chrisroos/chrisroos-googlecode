require 'erb'
include ERB::Util
require File.join(File.dirname(__FILE__), *%w[.. lib swimming_pools])

template = DATA.read
public_dir = File.join(File.dirname(__FILE__), '..', 'public')

SwimmingPools.find_all.each do |swimming_pool|
  erb = ERB.new(template)
  File.open(File.join(public_dir, "#{swimming_pool.permalink}.html"), 'w') do |file|
    file.puts(erb.result(binding))
  end
end

__END__
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%= h(swimming_pool.name) %></title>
  </head>
  <body>
    <h1><%= h(swimming_pool.name) %></h1>
    
    <dl>
      <dt>Address</dt>
      <dd class="address"><%= h(swimming_pool.address) %></dd>
      <dt>Postcode</dt>
      <dd class="postcode"><%= h(swimming_pool.postcode) %></dd>
      <dt>Latitude</dt>
      <dd class="latitude"><%= h(swimming_pool.latitude) %></dd>
      <dt>Longitude</dt>
      <dd class="longitude"><%= h(swimming_pool.longitude) %></dd>
      <dt>Phone</dt>
      <dd class="phone"><%= h(swimming_pool.phone) %></dd>
      <dt>Fax</dt>
      <dd class="fax"><%= h(swimming_pool.fax) %></dd>
      <dt>Website</dt>
      <dd class="website"><a href="<%= h(swimming_pool.url) %>"><%= h(swimming_pool.url) %></a></dd>
      <dt>Email</dt>
      <dd class="email"><a href="mailto:<%= h(swimming_pool.email) %>"><%= h(swimming_pool.email) %></a></dd>
    </dl>
    
    <% img_url = 'http://maps.google.com/staticmap?' %>
    <% img_url_params = ["center=#{swimming_pool.latitude},#{swimming_pool.longitude}"] %>
    <% img_url_params << 'zoom=14' %>
    <% img_url_params << 'size=300x300' %>
    <% img_url_params << "markers=#{swimming_pool.latitude},#{swimming_pool.longitude}" %>
    <% img_url_params << 'key=ABQIAAAAKHjf8pvj0mv3o07jD0Tc5RQaqNW12GnHBM9UqBhN-tKTStROsxS_YKqdsgFyjjinVKdFKNOHhZmPOQ' %>
    <% img_url = img_url + img_url_params.join('&') %>
    <p><img src="<%= h(img_url) %>" width="300" height="300" alt="<%= h(swimming_pool.name) %>" /></p>
    
    <script type="text/javascript">
      var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
      document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
    </script>
    <script type="text/javascript">
      var pageTracker = _gat._getTracker("UA-160238-6");
      pageTracker._initData();
      pageTracker._trackPageview();
    </script>
  </body>
</html>