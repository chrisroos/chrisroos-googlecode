namespace :deliciolytics do
  
  namespace :domain do
    
    desc 'Extract all the URLs from the domain sitemap'
    task :update_urls => :environment do
      Domain.all.each do |domain|
        domain.retrieve_urls_from_sitemap!
      end
    end
    
    desc 'Normalise all the domains'
    task :normalise => :environment do
      Domain.all.each do |domain|
        domain.normalise!
      end
    end
    
  end
  
end