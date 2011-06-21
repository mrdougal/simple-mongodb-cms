
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
    
  
  def find_page

    return unless params[:slug]

    @page = Page.find_by_slug(params[:slug]).first

    # Send this on to the next matching route
    # which is the 404/missing page
    return not_found if @page.nil?

  end

  
    
end
