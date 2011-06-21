# encoding: UTF-8


#   This file contains the models which are ultimately saved to MongoDB 
#   We're using MongoID which is an Object Document Mapper (ODM) written in Ruby
#   http://mongoid.org/
#   
#   We are writting the database queries into a log file (logs/mongodb.log) so you can
#   tail the log to see what is happening within the application. 
#   
#   Fortunately queries in mongodb are easy to read
#   as you effectively pass a javascript object to the find method
#   
#       the db    the collection
#         |           |
#         |           |          key        desired value
#         |           |           |             |
#     simple_cms['pages'].find({ "slug" : "this-is-my-1st-post"})


class Page


  include Mongoid::Document
  include Mongoid::Timestamps
  
  
  # Fields in our MongoDB document
  # Mongoid will create getters and setters for each of these fields
  # eg: page['title'] = 'About us'
  #     page.title    = 'About us'
  
  field :title
  field :body
  field :tags, :type => Array, :default => []
  field :slug
  field :published, :type => Boolean, :default => false 








  # Minimal validations on our models
  validates_uniqueness_of :title
  validates_presence_of :title
  
  # Create a slug to be used for SEO urls
  after_validation :create_slug
  
  
  # We have embedded documents within a page
  embeds_many :comments
  
  
  # Shorthand for 'to string'
  def to_s
    self['title']
  end
  
  # url to the page
  def url
    Site.url_base.dup << (slug or '')
  end
  
  def slug
    self['slug']
  end
  
  # Convert the array of tags into a comma seperated string
  # for display in the form (so it's easily edited by the user)
  def tags_to_s

    self['tags'].inject([]) do |out, tag|
      out << to_slug(tag)
    end.join(', ')
  end
  
  
  # Split a string of comma seperated values 
  # so that we can store them as an array
  def tags= string
    
    self['tags'] = string.split(',').map do |tag|
      
      # Remove any excess whitespace
      tag.strip
    end
  end


  def body_html
    to_html(self.body)
  end
  
  # Returns a boolean
  def published?
    !!self['published']
  end
  
  
  
  # These are class methods
  class << self
    

    def published
      where :published => true
    end
    
    def find_by_slug val
      where :slug => val.to_s
    end


    def find_by_tags tags
      any_in :tags => tags
    end
    

  end
 
 
  
  private
  
	
  # Createa url friendly string from the page title
  def create_slug
    self.slug = to_slug(self.title)
  end
  
  
  # * convert to a string...
  # * strip whitespace
  # * downcase
  # * identify the string (convert spaces to hyphens)
	def to_slug string
	  
	  return if string.nil?
  	string.to_s.strip.downcase.identify
	end
	
end


#   Multiple comments can be embedded within a page (they are stored as an array)
# 
# 
#     page {
#             id: 4e001440fb8d5f9044000001
#             title: 'Living the webscale dream with MongoDB '
#             body: 'Recently we started using MongoDB in our product...' 
# 
#             comments: [
#                 { id: 4e001440fb8d5f9044000002,
#                   author: 'Trevor Wilson',
#                   body: 'This is awesome stuff...'
#                 },
#                 { id: 4e001440fb8d5f9044000003,
#                   author: 'John Doe',
#                   body: 'We have been using MongoDB at my work...'
#                 }]
#       
#     }
# 
# 
class Comment
  
  
  include Mongoid::Document
  
  embedded_in :page, :inverse_of => :comments
  
  field :author
  field :email
  field :body
  
  
  validates_presence_of :author, :body
  
  
  def to_s
    body
  end
  
  def body_html
    to_html(self.body)
  end
  
end  
  
  
  
  
  def to_html markdown
  	Maruku.new(markdown).to_html
  end

  
