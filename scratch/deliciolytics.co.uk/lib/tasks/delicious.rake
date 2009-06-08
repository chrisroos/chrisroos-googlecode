namespace :delicious do

  desc 'Update URL history for every URL registered within every domain'
  task :update_urlinfo => :environment do
    Domain.all.each do |domain|
      domain.update_urlinfo_from_delicious!(2)
    end
  end
  
  desc 'Download all bookmarks for every URL registered within every domain'
  task :import_bookmarks => :environment do
    Domain.all.each do |domain|
      domain.import_bookmarks_from_delicious!(2)
    end
  end
  
end