# Tell ruby to look
# $LOAD_PATH.unshift(File.dirname(__FILE__) + '/app')

require 'sinatra'
require 'mongoid'
require 'erb'


# The Mongodb model
# -----------------
require './app/config'
require './app/page'







# Sinatra application
# -------------------


helpers do 

  # String strings
  def strip string
    return if string.nil?
    string.to_s.strip
  end
  
  # human date
  def human_date string
    string.strftime "%e %b %Y"
  end
    
end

layout 'layout'

# The homepage
get "/" do
  
  @pages = Page.all
  
  erb :index
  
end


# Init a new page
get "/new" do
  
  @page = Page.new
  
  erb :edit
  
end


# Display tags
get "/tags/:tag" do
  
  # params[:tag].split('/')
  @pages = Page.find_by_tags params[:tag].split('/')
  return not_found if @pages.empty?
  
  erb :index
  
end


# Create a page
post "/new" do
  
  @page = Page.new params['page']
  
  if @page.save
    redirect to(@page.slug)
  else
    erb :edit
  end
  
end

# Edit a page
get "/:slug/edit" do
  
  @title = 'Editing a page'
  @page = Page.find_by_slug params[:slug]
  
  # Send this on to the next matching route
  # which is the 404/missing page
  return not_found if @page.nil?
  
  erb :edit
  
end

# Update a page
post "/:slug" do

  @page = Page.find_by_slug params[:slug]
  
  # Send this on to the next matching route
  # which is the 404/missing page
  return not_found if @page.nil?

  if @page.update_attributes params[:page]
    redirect to(@page.slug)
  else
    erb :show
  end

end


# Show page
get "/:slug" do
  
  @page = Page.find_by_slug params[:slug]
  
  # Send this on to the next matching route
  # which is the 404/missing page
  pass if @page.nil?
  
  erb :show
  
end




# Feed
get "/feed" do
  
  @pages = Page.published :limit=>10
  
	content_type 'application/atom+xml', :charset => 'utf-8'
	builder :feed
	
end



# 404 page
not_found do

  status 404
  erb :missing

end


