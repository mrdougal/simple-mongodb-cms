# encoding: UTF-8

helpers do 

  # Strip whitespace from strings
  def strip string
    return if string.nil?
    string.to_s.strip
  end
  
  
  # Human readable date
  def human_date string
    string.strftime "%e %b %Y"
  end
    

  
end
  

