# 2011-06-07 
# Dougal MacPherson <hello@newfangled.com.au>
# 
# The model backed by MongoDB


require 'maruku'

def to_html markdown
	Maruku.new(markdown).to_html
end



class Page


  include Mongoid::Document
  include Mongoid::Timestamps
  
  
  # Fields in our MongoDB document
  # Mongoid will create getters and setters for each of these fields
  # eg: title= and title
  
  field :title
  field :body
  field :tags, :type => Array, :default => []
  field :slug
  field :published, :type => Boolean, :default => false 



  # Validations on our models
  validates_uniqueness_of :title
  validates_presence_of :title
  
  # Create a slug to be used for SEO urls
  after_validation :create_slug
  
  
  
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
  
  
  
  class << self
    
    def published val
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


# Comments are embedded in pages
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