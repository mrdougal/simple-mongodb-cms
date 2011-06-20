xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
	xml.title Site.title
	xml.id Site.url_base
	xml.updated @pages.first.created_at.iso8601 if @pages.any?
	xml.author { xml.name Site.author }

	@pages.each do |post|
		xml.entry do
			xml.title post.title
			xml.link "rel" => "alternate", "href" => post.url
			xml.id post.url
			xml.published post.created_at.iso8601
			xml.updated post.created_at.iso8601
			xml.author { xml.name Site.author }
      # xml.summary post.summary_html, "type" => "html"
			xml.content post.body_html, "type" => "html"
		end
	end
end