class RemoveFiltersFromDb < ActiveRecord::Migration
  
  def self.up
    execute("DELETE FROM text_filters WHERE name <> 'textile' AND name <> 'none'")
  end

  def self.down
    text_filters = [
      {:name => 'markdown', :description => 'Markdown', :markup => 'markdown', :filters => '--- []', :params => '--- {}'},
      {:name => 'smartypants', :description => 'SmartyPants', :markup => 'none', :filters => "--- \n- :smartypants", :params => '--- {}'},
      {:name => 'markdown smartypants', :description => 'Markdown with SmartyPants', :markup => 'markdown', :filters => "--- \n- :smartypants", :params => '--- {}'}
    ]
    text_filters.each do |filter|
      insert "INSERT INTO text_filters (name, description, markup, filters, params) 
              VALUES ('#{filter[:name]}', '#{filter[:description]}', '#{filter[:markup]}', '#{filter[:filters]}', '#{filter[:params]}')"
    end
  end
  
end