require 'sinatra'
require 'mongoid'
require 'erb'
require 'maruku'


Mongoid.configure do |config|
  name = "simple_cms"
  host = "localhost"
  config.allow_dynamic_fields = true
  config.master = Mongo::Connection.new.db(name)
end



# The Mongodb model
# -----------------

class Page


  include Mongoid::Document
  include Mongoid::Timestamps
  
  # include Maruku
  
  field :title
  field :body
  field :tags, :type => Array, :default => []
  field :slug
  
  validates_presence_of :title
  before_save :create_slug
  
  
  def to_s
    title
  end
  
  def tags_to_s
    self['tags'].inject([]) do |out, tag|
      out << to_slug(tag)
    end.join(', ')
  end
  
  def tags= string
    
    self['tags'] = string.split(',').map do |tag|
      tag.strip
    end
    
  end
  
  
  def body_html
    to_html(self.body)
  end
  
  def linked_tags
		self['tags'].inject([]) do |accum, tag|
			accum << "<a href=\"/past/tags/#{tag}\">#{tag}</a>"
		end.join(" ")
	end
  
  class << self
    
    def find_by_slug val
      find :first, :conditions => { :slug => val.to_s }
    end

  end
  
  private
  
  def to_html markdown
		Maruku.new(markdown).to_html
	end
	
	def to_slug string
  	string.to_s.downcase.gsub(' ','-') 
	end
	
  
  def create_slug
    self['slug'] = to_slug(self['title'])
  end
  
end



# Sinatra application
# -------------------


layout 'layout'

# The homepage
get "/" do
  
  @title = 'Simple CMS'
  @models = Page.all
  
  erb :index
  
end


# Init a new page
get "/new" do
  
  @page = Page.new
  
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
  
  @title = 'Editing a page'
  @page = Page.find_by_slug params[:slug]
  
  erb :edit
  
end

# Update a page
post "/:slug" do

  @page = Page.find_by_slug params[:slug]
  
  # Send this on to the next matching route
  # which is the 404/missing page
  pass if @page.nil?

  @page.update_attributes params[:page]
  
  
  erb :show
  
end


# Show page
get "/:slug" do
  
  @page = Page.find_by_slug params[:slug]
  
  # Send this on to the next matching route
  # which is the 404/missing page
  pass if @page.nil?
  
  erb :show
  
end

# 404 page
get "*" do
  
  status 404
  erb :missing
  
end