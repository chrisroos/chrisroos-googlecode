namespace :sitemap do
  
  desc 'Extract all the URLs from the domain sitemap'
  task :update_urls do
    Domain.all.each do |domain|
      domain.retrieve_urls_from_sitemap!
    end
  end
  
end

namespace :delicious do

  desc 'Update URL history for every URL registered within every domain'
  task :update_urlinfo => :environment do
    Domain.all.each do |domain|
      domain.update_urlinfo_from_delicious!
    end
  end
  
  desc 'Download all bookmarks for every URL registered within every domain'
  task :import_bookmarks => :environment do
    Domain.all.each do |domain|
      domain.import_bookmarks_from_delicious!
    end
  end
  
end