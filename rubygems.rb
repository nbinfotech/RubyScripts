#!/usr/bin/ruby

require 'nokogiri'
require 'open-uri'

# Remove existing file
if File.exist?("GemList")
  File.delete("GemList")
end

page = 1
@gem_only = Array.new
counter = 0
doc = Nokogiri::HTML(open('https://rubygems.org/gems?letter=A?page=1'))
	
# Extract the h2 headers
gem_name = doc.xpath('//h2[@class="gems__gem__name"]').text.split.to_a

# Get the number of pages to crawl
no_of_pages_to_crawl = doc.css('div.pagination a').children[-2].text.to_i
puts "[*] Crawling page right now : #{page} , Remaining : #{no_of_pages_to_crawl}"


def gem_filter(gem_list)
  gem_list.each_with_index  do |gem, gem_version_index|
    if (gem_version_index % 2) == 0
      @gem_only.push(gem)
    end
  end

end

gem_filter(gem_name)

# Excrat description list array
gem_desc = doc.xpath('//p[@class="gems__gem__desc t-text"]').children.to_a

# Get the total number of description list to later use in the array index
gem_counter = gem_desc.count



# File Handling

while counter < gem_counter

  file = File.open("GemList", "a")
  puts "#{counter+1} ) #{ @gem_only[counter]} == #{gem_desc[counter]}\n"
  file.write("#{counter+1} ) #{ @gem_only[counter]} == #{gem_desc[counter]}\n")

  counter += 1
end

file.close


# Success message!
puts "[*] Yay!Written to file. Nothing to do "
