require 'rubygems'
require 'nokogiri' 
require 'open-uri'  
	PAGE_URL = "http://ruby.bastardsbook.com/files/hello-webpage.html" 
	XML_URL=   "http://asciicasts.com/episodes.xml"  
    page = Nokogiri::HTML(open(PAGE_URL))
   	xml_page=Nokogiri::XML(open(XML_URL))
   	puts xml_page
	puts page.css("title")[0].name   # => title
	puts page.css("title")[0].text   # => My webpage
	links = page.css("a")
	puts links.length   # => 6
	puts links[0].text   # => Click here
	puts links[0]["href"] # => http://www.google.com
	news_links = page.css("a").select{|link| link['data-category'] == "news"}
	news_links.each{|link| puts link['href'] }

	xml_page.xpath("//channel").each do |post|
	  	puts post.xpath("//title").text
	  	puts post.xpath("//description").text
	  	puts post.xpath("//link")

		%w[title].each do |n|
    		puts post.at(n).text
  		end
	  end