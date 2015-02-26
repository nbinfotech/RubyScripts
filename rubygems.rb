#########################################################################
# Author  : nbinfotech (p).ltd						#
# Website : http://www.nbinfotech.com					#
# Email   : info@nbinfotech.com.np					#
# Script  : rubygems.rb							#
# About   : 								#
#	    rubygems.rb to crawl over http://rubygems.org and extract	#
#	    gem names along with its description. It is expected to work#
#	    as long as the page configuration is intact.		#
# 									#
# Date    : 1502270014							#
#########################################################################
#!/usr/bin/ruby

require 'nokogiri'
require 'open-uri'

# Remove existing file if any
if File.exist?("GemList")
  File.delete("GemList")
end

# Global and instance variables
$TOTAL = 1						
@gem_only = Array.new
letter = 'A'
page = 1


def gem_filter(gem_list)
  gem_list.each_with_index  do |gem, gem_version_index|
    if (gem_version_index % 2) == 0
      @gem_only.push(gem)
    end
  end

end



while letter != 'AA'
	
	doc = Nokogiri::HTML(open("https://rubygems.org/gems?letter=#{letter}&@page=#{page}"))
	no_of_pages_to_crawl = doc.css('div.pagination a').children[-2].text.to_i

	while page <= no_of_pages_to_crawl
		puts "\n[*] Crawling page right now : #{page} , Remaining : #{no_of_pages_to_crawl-page}"
    	progress = ''
	    1000.times do |i|
	     
	    # i is number from 0-999
	    j = i + 1
	     
	      # add 1 percent every 20 times
	      if j % 10 == 0
	        progress << "="
	        # move the cursor to the beginning of the line with \r
	        print "\r"
	        # puts add \n to the end of string, use print instead
	        print progress + " #{j / 10} %"
	     
	        # force the output to appear immediately when using print
	        # by default when \n is printed to the standard output, the buffer is flushed.
	        $stdout.flush
	        sleep 0.07
	      end
	    end


	  counter = 0
	  doc = Nokogiri::HTML(open("https://rubygems.org/gems?letter=#{letter}&page=#{page}"))
	  
	  # Extract the h2 headers
	  @gem_name = doc.xpath('//h2[@class="gems__gem__name"]').text.split.to_a
	  # Excrat description list array
	  @gem_desc = doc.xpath('//p[@class="gems__gem__desc t-text"]').children.to_a
	  # Get the total number of description list to later use in the array index
	  @gem_counter = @gem_desc.count

	  gem_filter(@gem_name)

		  while counter <= @gem_counter

		    File.open("GemList", "a") do |file|
		  	begin
			    puts "#{$TOTAL} ) #{ @gem_only[counter]} == #{@gem_desc[counter]}\n"
			    file.write("#{$TOTAL} ) #{ @gem_only[counter]} == #{@gem_desc[counter]}\n")

			rescue
				raise FileSaveError.new($!)

			end
			end

		    counter += 1
		    $TOTAL += 1
		  end

	  page += 1
	  @gem_only = []
	end
	
	letter = letter.next
	page = 1
	
end
letter.next


# Close if any open connection
file.close


# Success message!
puts "[*] Yay! Written to file. Nothing to do! Cheers @Amar :) "
