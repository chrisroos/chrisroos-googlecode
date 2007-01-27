class ContentsController < ApplicationController
  
  before_filter :authenticate
  
  def search
    @contents = Content.find_with_title_like(params[:q])
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @contents.to_xml(:only => [:id, :title]) }
    end
  end
  
  # GET /contents
  # GET /contents.xml
  def index
    @contents = Content.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @contents.to_xml }
    end
  end

  # GET /contents/1
  # GET /contents/1.xml
  def show
    begin
      @content = Content.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      respond_to do |format|
        format.html { render(:file => "#{RAILS_ROOT}/public/404.html", :status => :not_found) and return }
        format.xml  { head(:not_found) and return }
      end
    end

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @content.to_xml }
      format.text { render :text => @content.body }
    end
  end

  # GET /contents/new
  def new
    @content = Content.new
  end

  # GET /contents/1;edit
  def edit
    @content = Content.find(params[:id])
  end

  # POST /contents
  # POST /contents.xml
  def create
    @content = Content.new(params[:content])

    respond_to do |format|
      if @content.save
        flash[:notice] = 'Content was successfully created.'
        format.html { redirect_to content_url(@content) }
        format.xml  { head :created, :location => content_url(@content) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @content.errors.to_xml }
      end
    end
  end

  # PUT /contents/1
  # PUT /contents/1.xml
  def update
    begin
      @content = Content.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      respond_to do |format|
        format.html { render(:file => "#{RAILS_ROOT}/public/404.html", :status => :not_found) and return }
        format.xml  { head(:not_found) and return }
      end
    end

    respond_to do |format|
      if @content.update_attributes(params[:content])
        flash[:notice] = 'Content was successfully updated.'
        format.html { redirect_to content_url(@content) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @content.errors.to_xml }
      end
    end
  end

  # DELETE /contents/1
  # DELETE /contents/1.xml
  def destroy
    begin
      @content = Content.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      respond_to do |format|
        format.html { render(:file => "#{RAILS_ROOT}/public/404.html", :status => :not_found) and return }
        format.xml  { head(:not_found) and return }
      end
    end
    
    @content.destroy

    respond_to do |format|
      format.html { redirect_to contents_url }
      format.xml  { head :ok }
    end
  end
  
private
  def authenticate
    authenticate_or_request_with_http_basic do |user_name, password| 
      user_name == HTTP_USERNAME && password == HTTP_PASSWORD
    end
  end
    
end
