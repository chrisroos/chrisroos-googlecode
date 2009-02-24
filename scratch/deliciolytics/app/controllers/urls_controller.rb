class UrlsController < ApplicationController
  
  def index
    @urls = Url.find(:all, :order => 'total_posts DESC')
  end
  
end