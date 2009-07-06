# This class takes a name of a movie and gets data from imdb
# Author::    Stephen Becker IV  (mailto:sbecker@x.y@gmail )
# Copyright:: Copyright
# License::   Distributes under the same terms as Ruby
# version::  Doctor Zhivago(0.6)
require 'rubygems'
#needs version >= 0.5.00 of hpricot
#works with version 6.0 ruby
require 'hpricot'
require 'open-uri'
require 'uri'
require 'pp'
require "rexml/document"
require "date"

#read about my suggestion @ http://code.whytheluckystiff.net/hpricot/ticket/37
#this will just run next node X times
#node_at just did not float my boat.
module Hpricot
	module Traverse
		# Returns the node neighboring this node to the south: just below it.
		# This method includes text nodes and comments and such.
		def next_node(loop=1)
			sib = parent.children
			sib[ sib.index(self) + loop ] if parent
		end
	end
end

class IMDB
	class << self
		#returns a hash of the differnt titles and what they are
		#   {"Titles (Exact Matches)"=>["Office Space"],
		#"Titles (Partial Matches)"=>["'Office Space': Out of the Office"],
		#"Popular Titles"=>["Office Space"],
		#"Titles (Approx Matches)"=>["Spice Girls: One Hour of Girl Power"]}
		def title_search(title)
			movie_name = title
			movie_name.downcase!
			#_ is used in the folder names
			movie_name.gsub!("_","+")
			movie_name.gsub!(" ","+")
			doc = Hpricot(open(URI.encode("http://www.imdb.com/find?s=all&q=#{movie_name}")))
			array = Array.new
			doc.search("p").each{|x| array.push(x) if  !x.search("table").nil? && !x.search("b").first.nil? &&  x.search("b").first.inner_html.to_s.downcase.include?("title") }
			title_links = {}
			array.each{|x| title_links.merge!({x.search("b").first.inner_html => x.search("a").collect{|z| z.inner_html}.delete_if{|u| u.include?("<img")}.uniq})}
			title_links
		end
	end

	#We save some things for a single load of the page
	#other things do not need to be saved
	# options_hash has keys
	#	:interactive_load default is false if true you get a command line menu
	# 	:movies_only	default is true, set to false to allow tv shows in list of links
	def initialize(movie="",options_hash = {:movies_only => true,:interactive_load => false})
		@imdb_link = nil
		#max guessing links
		@MAXCOUNT = 15
		@html_info_tags = nil
		#if you want tv shows pass this as false
		@movies_only = options_hash[:movies_only]
		#does command line menu if true
		@interactive_load =  options_hash[:interactive_load]|| false
		#not title
		@movie_name = movie
		#html section of imdb that includes the poster year title director
		@short_details = nil
		#html of the whole page. only get this once
		@page_html = nil
		#viewing time
		@movie_length = nil
		#plot
		@movie_plot = nil
		#cast_html that will be replaced with a better representation
		@cast_html = nil
		@movie_title = nil
		@movie_year = nil
	end

	##Complete html of page
	def page_html
		load_page.to_html
	end
	alias_method :to_html,:page_html
	alias_method :html,:page_html

	# the link to the poster
	def poster_link
		doc=load_page
		#just following the xpath
		(doc/"//a[@name='poster']/img").first["src"]
	end

	#the link
	def imdb_link
		@imdb_link
	end


	def to_xml
		data = REXML::Document.new("<?xml version='1.0' encoding='ISO-8859-1'?>")
		base = data.add_element("movie")
		base.attributes["name"] = self.title
		base.attributes["api_version"] = "0.2"
		a=base.add_element("cast")
		actors.each{|key,value|
			b=a.add_element("actor")
			b.add_element("name").text = key
			b.add_element("role").text = value
		}
		base.add_element("run_time").text = runtime
		base.add_element("plot").text = plot
		base.add_element("director").text=directors.join(",")
		base.add_element("writer").text=writers.join(",")
		#dont think the link plays nice with xml, need to use
		#base.add_element("poster link").text=poster
		#CGI::escapeHTML(string) or ERB::Util.html_escape
		base.add_element("link").text=imdb_link
		base.add_element("title").text=title
		base.add_element("date").text=date.to_s
		base.add_element("rating").text=mpaa
		base.add_element("user_comments").text=user_comments
		base.add_element("tag_line").text=tagline
		base.add_element("plot").text=plot
		#base.add_element("keywords").text=unescapeHTML(keywords.join(","))
		g=base.add_element("genres")
		genres.each{|value|
			g.add_element("type").text=value
		}
		result = ""
		data.write(result)
		return result
	end

	#returns an array of the possable titles for a search.
	#if its not in the list try a differnt name
	def title_search
		IMDB.title_search(@movie_name)
	end
	###############olds
	def tagline
		#"Work Sucks."
		elements = page_info_tags.select{|x| text_clean(x.search("h5").text())=="tagline"}
		if elements.first
			elements.first.search("h5").first.next_node.to_s.strip
		else
			""
		end
	end

	#returns an array of genres
	def genre
		#["Comedy", "Crime"]
		elements = page_info_tags.select{|x| text_clean(x.search("h5").text())=="genre"}
		if elements.first
			elements.first.search("a").select{|z| !z.classes.include?("inline")}.collect{|b| b.inner_html}
		else
			""
		end
	end
	alias_method :genres,:genre

	#returns a date object with the release date
	def release_date
		#19 February 1999 (USA)
		z = page_info_tags.select{|x| text_clean(x.search("h5").text())=="release_date"}
		return Date.new unless z.first
		date2 = z.first.search("h5").first.next_node.to_s.strip.split
		day = date2[0]
		month = Date::MONTHNAMES.index(date2[2])
		year = date2[3]
		Date.parse(date2[0...3].join(" "),"%d %B %Y")

	end
	alias_method :date,:release_date

	#returns an array of writers
	def writer
		#["Mike Judge"]
		elements = page_info_tags.select{|x| text_clean(x.search("h5").text()) =~ %r(^writer)}
		if elements.first
			elements.first.search("a").select{|z| !z.inner_html.include?('(WGA)') && !z.classes.include?("tn15more")}.collect{|b| b.inner_html.to_s.strip}.uniq
		else
			Array.new
		end
	end
	alias_method :writers,:writer

	#returns an array of directors
	def director
		#["Mike Judge"]
		elements = page_info_tags.select{|x| text_clean(x.search("h5").text())=~/^director/}
		if elements.first
			elements.first.search("a").select{|z| !z.classes.include?("tn15more")}.collect{|b| b.inner_html.to_s.strip}.uniq
		else
			Array.new
		end
	end
	alias_method :directors,:director

	#a string with what hollywood calls plot these days
	def plot
		#Comedic tale of company workers who hate their jobs and decide to rebel against their greedy boss.
		elements = page_info_tags.select{|x| text_clean(x.search("h5").text())=="plot"}
		if elements.first
			elements.first.search("h5").first.next_node.to_s.strip
		else
			""
		end
	end
	alias_method :plot_outline,:plot

	#not sure about supporting this yet
	#["This plot synopsis is empty. Add a synopsis"]
	#@html_info_tags.select{|x| text_clean(x.search("h5").text())=="plot_synopsis"}.first.search("a").select{|z| !z.classes.include?("inline")}.collect{|b| b.inner_html}

	#an array of key words?
	#["Hypnosis", "Cult&#160;Comedy", "Kung&#160;Fu", "Post&#160;It", "Arson"]
	def plot_keywords
		elements = page_info_tags.select{|x| text_clean(x.search("h5").text())=="plot_keywords"}
		if elements.first
			elements.first.search("a").select{|z| !z.classes.include?("inline")}.collect{|b| unescapeHTML(b.inner_html)}
		else
			Array.new
		end
	end
	alias_method :keywords,:plot_keywords

	#string i hope.
	#2 nominations
	def awards
		elements = page_info_tags.select{|x| text_clean(x.search("h5").text())=="awards"}
		if elements.first
			elements.first.search("h5").first.next_node.to_s.strip
		else
			""
		end
	end

	#some say its cheating... @html_info_tags.select{|x| text_clean(x.search("h5").text())=="[[%s]]"}.first.search("h5").first.next_node.to_s.strip#
	#string of some user comments
	def user_comments
		elements = page_info_tags.select{|x| text_clean(x.search("h5").text())=="user_comments"}
		if elements.first
			elements.first.search("h5").first.next_node.to_s.strip
		else
			""
		end
	end

	#title else where in the world
	#now returns an array
	def also_known_as
		elements = page_info_tags.select{|x| text_clean(x.search("h5").text())=="also_known_as"}
		if elements.first
			elements.first.search("h5").collect{|node| node.next_node.to_s.strip}
		else
			[]
		end

	end

	alias_method :aka,:also_known_as

	#string of the rating and why
	def mpaa
		elements = page_info_tags.select{|x| text_clean(x.search("h5").text())=="mpaa"}
		if elements.first
			elements.first.search("h5").first.next_node.to_s.strip
		else
			""
		end
	end
	alias_method :ratings,:mpaa
	alias_method :rating,:mpaa

	#string # min (hopefully is the format)
	def runtime
		elements = page_info_tags.select{|x| text_clean(x.search("h5").text())=="runtime"}
		if elements.first
			elements.first.search("h5").first.next_node.to_s.strip
		else
			""
		end
	end

	#country as a string. most likely abbrv
	def country
		elements = page_info_tags.select{|x| text_clean(x.search("h5").text())=="country"}
		if elements.first
			elements.first.search("h5").first.next_node(2).inner_html
		else
			""
		end
	end

	#orgrinal lang
	def language
		elements = page_info_tags.select{|x| text_clean(x.search("h5").text())=="language"}
		if elements.first
			elements.first.search("h5").first.next_node(2).inner_html
		else
			""
		end
	end

	#was it shot in color?
	def color
		elements = page_info_tags.select{|x| text_clean(x.search("h5").text())=="color"}
		if elements.first
			elements.first.search("h5").first.next_node(2).inner_html
		else
			""
		end
	end

	#string
	def aspect_ratio
		elements = page_info_tags.select{|x| text_clean(x.search("h5").text())=="aspect_ratio"}
		if elements.first
			elements.first.search("h5").first.next_node.to_s.strip
		else
			""
		end
	end
	alias_method :aspect,:aspect_ratio

	# returns a string with company name
	def company
		elements = page_info_tags.select{|x| text_clean(x.search("h5").text())=="company"}
		if elements.first
			elements.first.search("h5").first.next_node(2).inner_html
		else
			""
		end
	end

	#ratings around the world. its a hash!
	def certification
		cert_hash = {}
		begin
			#{"UK"=>"15", "Ireland"=>"15", "Chile"=>"TE", "Australia"=>"M", "Argentina"=>"Atp", "Iceland"=>"L", "Sweden"=>"Btl", "Portugal"=>"M/12", "Spain"=>"T", "USA"=>"R", "Finland"=>"S", "France"=>"U", "Peru"=>"PT", "Canada"=>"AA", "Norway"=>"7", "Germany"=>"12", "Netherlands"=>"AL"}
			page_info_tags.select{|x|
				text_clean(x.search("h5").text())=="certification"}.first.search("a").select{|z|
					!z.classes.include?("inline")
					}.each{|b|
						xx = b.inner_html.split(':')
						cert_hash.merge!({xx[0]=>xx[1]})
					}
		rescue Exception => e
		end
		cert_hash
	end
	alias_method :certs,:certification
	alias_method :certifications,:certification

	#just the title incase it is differnt then the one you had used
	def title
		doc = load_page
		title  = doc.search("h1").first.inner_html.split(%r(<span>))[0].chop
		clean_html_tags(title)
		clean_9_0(title)
		title
	end

	def actors
		doc = load_page
		p = {}
		begin
			doc.search("table[@class='cast']").first.search("tr").each{|x|
				p.merge!({
						x.search("td[@class='nm']/a").inner_html => x.search("td[@class='char']").inner_html
						})
			}
		rescue Exception =>e
		end
		p
	end
	alias_method :cast,:actors

	private

	#needs better xpath
	#gets the upper level to find the poster html. should be broken out in xpaths
	def details_based_on_poster_attribute
		doc = load_page
		data = []
		doc.search("table").each{|rate|  (rate/"a").each{|link| data.push(rate) if link.attributes['name']=="poster"  }}
		return data
	end

	#so i dont have to run the info tag search alot
	def page_info_tags
		unless @html_info_tags
			doc = load_page
			@html_info_tags = doc.search("div[@class='info']")
		end
		@html_info_tags
	end

	#loads the page data once and stores it in @page_html also contains logic
	#for which link to pick from the search
	def load_page
		#check if we have page html if so return
		if @page_html
			doc = Hpricot(@page_html)
		else
			#alter the passed in name to fit the imdb search, use local copy
			#bad use of names..
			movie_name = "#{@movie_name}"
			movie_name.downcase!
			#_ is used in the folder names
			movie_name.gsub!("_","+")
			movie_name.gsub!(" ","+")
			connection = open(URI.encode("http://www.imdb.com/find?s=all&q=#{movie_name}"))
			doc = Hpricot(connection)
			#find all links
			elements = doc.search("a")
			arr = []
			#if the inner html of the partent object to the link matchs it
			#should be a movie. I would get matches for media link items before
			elements.each{|link|
				if link.parent.inner_html =~ /<br\s*\/><a.*href=["|']\/title\/tt\d*\/["|'].*>.*?<.a>\s\(\d\d\d\d\)/
					#if movies only is set do not get the ones with tv series in them
					if !@movies_only || (@movies_only && !link.parent.inner_html.include?("TV series"))
						arr.push([link.attributes['href'],link.inner_html])
					end
				end
				}
			if doc.search("h1").first.nil?
				#use the first link with the same name as what we search for create a
				#menu system if more or create more then one entry?
				if !@interactive_load
					#try to find movie with same name if not go with first.
					movie = arr.select{|elm| elm[1].strip.downcase == @movie_name}
					movie.push(arr.first)
					@imdb_link = "http://www.imdb.com#{movie.first[0]}"
				else
					@imdb_link = "http://www.imdb.com"+movie_menu(elements)
				end
				doc=Hpricot(open(@imdb_link))
				@page_html = doc.to_html
				@html_info_tags = doc.search("div[@class='info']")
				#some movies do not take you to a search page example is robin hood men
				#in tights i guess sometimes there is no need for a search page
			elsif (doc/"/html/head/title").inner_html!="IMDb Search"
				@imdb_link = "http://www.imdb.com/find?s=all&q=#{movie_name}"
				@page_html = doc.to_html
				@html_info_tags = doc.search("div[@class='info']")
			else
				#all searches have failed
				raise "Error: No Inner HTML links found!"
			end
		end
		return doc
	end


	#@html_info_tags = doc.search("div[@class='info']")
	def movie_menu(elements)
		count = 0
		array = []
		puts "Pick a number to load"
		elements.each{|link|
			if link.attributes['href'] && link.attributes['href'].include?('/title/') && count<@MAXCOUNT
				puts count.to_s+")"+unescapeHTML(link.inner_html)+" "+link.next_node.to_s
				array.push(link.attributes['href'])
				count = count+1
			end
		}
		number = gets
		return array[number.to_i%array.size]
	end

	#needed to clean a few things
	def text_clean(text)
		cleaned = text
		cleaned.downcase!
		clean_html_tags(cleaned)
		clean_9_0(cleaned)
		cleaned.gsub!(/[^a-z\s]*/,'')
		cleaned.strip!
		cleaned.gsub!(/ /,'_')
		cleaned
	end
	def clean_html_tags(cleaned)
		cleaned.gsub!(/<[^<]*>/,'')
	end
	def clean_9_0(cleaned)
		cleaned.gsub!(/\([^\(]*\)/,'')
	end
	#Jacked from http://www.rubycentral.com/book/tut_stdtypes.html
	def unescapeHTML(string)
		str = string.dup
		str.gsub!(/&(.*?);/n) {
			match = $1.dup
			case match
			when /\Aamp\z/ni           then '&'
			when /\Aquot\z/ni          then '"'
			when /\Agt\z/ni            then '>'
			when /\Alt\z/ni            then '<'
			when /\A#(\d+)\z/n         then Integer($1).chr
			when /\A#x([0-9a-f]+)\z/ni then $1.hex.chr
			end
		}
		str
	end

end
if $0==__FILE__
	begin
		["slumdog+millionaire","scotland pa","MaLlRaTs"].each{|movie|#,"Doctor+Zhivago","blue_velvet","die hard","die hard 2","ghost in the shell","pi","office_space","11:14","high plains drifter"].each{|movie|
			next unless movie
			puts movie
			movie=IMDB.new(movie)# or office_space or OFFICE_SPACE
			#pp movie.get_links
			pp movie.actors
			pp movie.title
			pp movie.poster_link
			pp movie.rating
			pp movie.aka
			pp movie.also_known_as
			pp movie.aspect
			pp movie.aspect_ratio
			pp movie.awards
			pp movie.certification
			pp movie.certifications
			pp movie.certs
			pp movie.color
			pp movie.company
			pp movie.country
			pp movie.date
			pp movie.director
			pp movie.directors
			pp movie.genre
			pp movie.genres
			pp movie.imdb_link
			pp movie.keywords
			pp movie.language
			pp movie.mpaa
			pp movie.page_html
			pp movie.plot
			pp movie.plot_keywords
			pp movie.plot_outline
			pp movie.poster_link
			pp movie.rating
			pp movie.ratings
			pp movie.release_date
			pp movie.runtime
			pp movie.tagline
			pp movie.user_comments
			pp movie.writer
			pp movie.writers
			pp movie.title_search
			pp movie.to_xml
			sleep 30
		}
	rescue Exception=>e
		puts "------------"+e
		puts e.backtrace*"\n"
	end

	begin
		pp IMDB.title_search("white strips")
	rescue Exception => e
		pp e
	end
end
