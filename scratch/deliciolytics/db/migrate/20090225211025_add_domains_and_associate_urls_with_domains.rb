class AddDomainsAndAssociateUrlsWithDomains < ActiveRecord::Migration
  
  def self.up
    create_table :domains, :force => true do |t|
      t.string :domain
      t.string :domain_hash
      t.timestamps
    end
    
    add_column :urls, :domain_id, :integer
  end

  def self.down
    remove_column :urls, :domain_id
    drop_table :domains
  end
  
end