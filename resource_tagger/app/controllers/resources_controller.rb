class ResourcesController < ApplicationController
  # GET /resources
  # GET /resources.xml
  def index
    @resources = Resource.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @resources.to_xml }
    end
  end

  # GET /resources/1
  # GET /resources/1.xml
  def show
    @resource = Resource.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @resource.to_xml }
    end
  end

  # GET /resources/new
  def new
    @resource = Resource.new
  end

  # GET /resources/1;edit
  def edit
    @resource = Resource.find(params[:id])
  end

  # POST /resources
  # POST /resources.xml
  def create
    @resource = Resource.new(params[:resource])

    respond_to do |format|
      if @resource.save
        flash[:notice] = 'Resource was successfully created.'
        format.html { redirect_to resource_url(@resource) }
        format.xml  { head :created, :location => resource_url(@resource) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @resource.errors.to_xml }
      end
    end
  end

  # PUT /resources/1
  # PUT /resources/1.xml
  def update
    @resource = Resource.find(params[:id])

    respond_to do |format|
      if @resource.update_attributes(params[:resource])
        flash[:notice] = 'Resource was successfully updated.'
        format.html { redirect_to resource_url(@resource) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @resource.errors.to_xml }
      end
    end
  end

  # DELETE /resources/1
  # DELETE /resources/1.xml
  def destroy
    @resource = Resource.find(params[:id])
    @resource.destroy

    respond_to do |format|
      format.html { redirect_to resources_url }
      format.xml  { head :ok }
    end
  end
end
