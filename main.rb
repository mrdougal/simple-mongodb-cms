# Tell ruby to look
# $LOAD_PATH.unshift(File.dirname(__FILE__) + '/app')

require 'sinatra'
require 'mongoid'
require 'erb'


# Our application
# -----------------
require './app/config'
require './app/page'
require './app/helpers'


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
  
  find_page
  @title = 'Editing a page'
  
  erb :edit
  
end

# Update a page
post "/:slug" do

  find_page
  
  if @page.update_attributes params[:page]
    redirect to(@page.slug)
  else
    erb :show
  end

end


# Show page
get "/:slug" do
  
  find_page
  erb :show
  
end

# Create a comment on a page
post "/:slug/comments" do
  
  find_page
  @page.build_comments params[:comment]
  
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


