# encoding: UTF-8

# Tell ruby to look
# $LOAD_PATH.unshift(File.dirname(__FILE__) + '/app')

require 'sinatra'
require 'mongoid'
require 'erb'

# For converting text input into html
require 'maruku'



# Our application
# -----------------
require './app/config'
require './app/helpers'
require './app/models'



def find_page

  return unless params[:slug]

  @page = Page.find_by_slug(params[:slug]).first
  
  # MongoDB query
  # db.pages.find({ "slug" : slug }).limit(1)
  

  # Send this on to the next matching route
  # which is the 404/missing page
  return not_found if @page.nil?

end




# The homepage
get "/" do
  
  @pages = Page.published
  
  # MongoDB query
  # db.pages.find({ "published" : true })
  

  if @pages.empty?
    
    # If we don't have any pages published give them an empty page
    @title = "No posts to show"
    erb :empty
  else
    erb :index
  end
end

# Feed
get "/feed" do
  
  @pages = Page.published :limit => 10
  
  # MongoDB query
  # db.pages.find({ "published" : true }, { "limit" : 10 })
  
  
	content_type 'application/atom+xml', :charset => 'utf-8'
	builder :feed
	
end


# Show all pages (published or not)
get "/all" do
  
  @pages = Page.all

  # MongoDB query...
  # db.pages.find()
  
  

  if @pages.empty?
    
    # If we don't have any pages published give them an empty page
    @title = "No posts to show"
    erb :empty
  else
    erb :index
  end
end


# Display tags
get "/tags/:tag" do
  

  @pages = Page.find_by_tags params[:tag].split('/')

  # MongoDB query
  # db.pages.find({ "tags" : { "$in" : [ tag1, tag2 ]}  })
  # 
  # '$in' all values present to match
  # '$or' any values present to match
  # '$ne' no values present to match

  return not_found if @pages.empty?
  
  erb :index
  
end




# Init a new page
get "/new" do
  
  @page = Page.new
  @title = 'Create a new page'
  erb :edit
  
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





# 404 page
not_found do

  status 404
  erb :missing

end


