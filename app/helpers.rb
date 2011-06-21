
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
