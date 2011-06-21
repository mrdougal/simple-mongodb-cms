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
  @title = 'Create a new page'
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

get "/:slug/delete" do
  
  find_page
  @page.delete

  # Display a message to the user
  erb "The page <strong>\"#{@page}\"</strong> and it's comments was deleted."
  
end

# Show page
get "/:slug" do
  
  find_page
  erb :show
  
end



# ********
# Comments
# ********

# Create a comment on a page
post "/:slug/comments" do
  
  find_page
  
  # Build the comment based on the params
  @comment = Comment.new params[:comment] 
  
  
  if @comment.valid?
    
    @comment['created_at'] = Time.now
    @page.comments << @comment
    @page.save
  
    redirect to(@page.url)

  else
    
    # We don't have a valid comment
    erb :comment
    
  end
  
  
end

get "/:slug/comments/new" do
  
  find_page
  
  @comment = Comment.new
  
  erb :comment
  
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


