class AddMissingHyphenatedTagsFromArticleKeywords < ActiveRecord::Migration
  
  def self.up
    articles = Article.find(:all, :select => "id, keywords", :conditions => 'keywords LIKE "%-%"')
    articles.each do |article|
      hyphenated_tags = article.keywords.split(' ').select { |word| word =~ /.+-.+/ }
      hyphenated_tags.each do |tag_name|
        tag = Tag.find_or_create_by_name(tag_name)
        article.tags << tag
      end
    end
  end
  
  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
  
end

module Migration009
  class Article < ActiveRecord::Base
    has_and_belongs_to_many :tags, :foreign_key => 'article_id', :order => 'name'
  end
  class Tag < ActiveRecord::Base
    has_and_belongs_to_many :articles, :order => 'published_at DESC'
  end
end
AddMissingHyphenatedTagsFromArticleKeywords.__send__(:include, Migration009)