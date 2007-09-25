class ArticlesController < ApplicationController
  
  def list
    @articles = Article.find_recent
  end
  
end