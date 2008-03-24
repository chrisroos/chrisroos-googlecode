PUBLIC_DIRECTORY = File.join(File.dirname(__FILE__), 'public')
Articles = []

def add_articles(articles_directory)
  Dir[File.join(PUBLIC_DIRECTORY, articles_directory, '*.html')].each do |file|
    Articles << File.join('/', articles_directory, File.basename(file, '.html'))
  end
end

# Isle of Thanet Gazette
add_articles File.join('isle-of-thanet-gazette', '2008', '01', '04')
add_articles File.join('isle-of-thanet-gazette', '2008', '01', '11')
add_articles File.join('isle-of-thanet-gazette', '2008', '01', '18')
add_articles File.join('isle-of-thanet-gazette', '2008', '01', '25')
add_articles File.join('isle-of-thanet-gazette', '2008', '02', '08')
add_articles File.join('isle-of-thanet-gazette', '2008', '02', '15')

# Thanet Adscene
add_articles File.join('thanet-adscene', '2008', '01', '10')
add_articles File.join('thanet-adscene', '2008', '01', '17')
add_articles File.join('thanet-adscene', '2008', '01', '24')
add_articles File.join('thanet-adscene', '2008', '01', '31')
add_articles File.join('thanet-adscene', '2008', '02', '07')
add_articles File.join('thanet-adscene', '2008', '02', '14')

# Thanet Times
add_articles File.join('thanet-times', '2008', '01', '08')
add_articles File.join('thanet-times', '2008', '01', '15')
add_articles File.join('thanet-times', '2008', '01', '22')
add_articles File.join('thanet-times', '2008', '01', '29')
add_articles File.join('thanet-times', '2008', '02', '05')
add_articles File.join('thanet-times', '2008', '02', '12')

# Output Sitemap
SITEMAP_PATH = File.join(PUBLIC_DIRECTORY, 'sitemap.xml')

require 'erb' 
include ERB::Util

template = %{<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <% Articles.each do |article| %>
    <url><loc>http://the-local-paper.co.uk<%= h(article) %></loc></url>
  <% end %>
</urlset>
} 
erb = ERB.new(template) 
File.open(SITEMAP_PATH, 'w') { |file| file.puts(erb.result) }