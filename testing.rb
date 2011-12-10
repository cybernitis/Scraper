require 'uri'
require 'open-uri'
require 'soap/wsdlDriver'
#require 'rexml/document'
require 'cgi'

puts "What site would you like to scrape:"
url = gets.chomp!

if url !~ /http|www/i
 url.gsub!(url, 'http://www.' + url)

elsif url =~ /www/i

 if url !~ /http/i

  url.gsub!(url, 'http://' + url)

 end

end

content = open(url).read()

html = CGI::unescapeHTML(content)
#Remove http://www. from the url to make a filename and add .html to the end
basedir = url.gsub!(/http:\/\/www./, "")
#Remove .com as well
filename = basedir.gsub!(/.com/, "")

 puts "Scraping #{filename} to #{basedir}/..."
#Create a file in the same directory and use previously defined naming convention
local_html = File.new(filename + ".html", "w")
#Write the html file
File.open(local_html, 'w') {|f| f.write(html) }

###############################
#Now find the links and paths #
###############################

 links = html.scan(/href\S+"/).join("\n").scan(/"\S+"/)

puts "Your scrape of #{url.upcase} contains the following links:"

links.each{ |link|

if link =~ /.com/ && /(?!\/#{filename}\/)/

  if link =~ /#{filename}/

    i_link = link
    print "Internal link - " + i_link + "\n"

else

  e_link = link
    print "External link - " + e_link + "\n"
end

elsif link !~ /#{filename}\./

  path = link
    print "Path - " + path + "\n"


end
}

##########################################
#Now follow the internal links and paths #
##########################################

