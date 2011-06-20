# 2011-06-07 
# Dougal MacPherson <hello@newfangled.com.au>
# 
# The model backed by MongoDB

require 'maruku'

class Page


  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::MultiParameterAttributes 
  
  
  field :title
  field :body
  field :tags, :type => Array, :default => []
  field :slug
  
  validates_presence_of :title
  before_save :create_slug
  
  # Shorthand for 'to string'
  def to_s
    self['title']
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

  def body
    self['body']
  end
  
  def body_html
    to_html(self.body)
  end
  
  
  class << self
    
    def find_by_slug val
      find :first, :conditions => { :slug => val.to_s }
    end

    def find_by_tags tags
      any_in :tags => tags
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
    self['slug'] = to_slug(self['title'].strip)
  end
  
end

