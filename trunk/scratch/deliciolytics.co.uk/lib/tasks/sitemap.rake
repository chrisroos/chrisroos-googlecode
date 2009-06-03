namespace :sitemap do
  
  desc 'Extract all the URLs from the domain sitemap'
  task :update_urls => :environment do
    Domain.all.each do |domain|
      domain.retrieve_urls_from_sitemap!
    end
  end
  
end