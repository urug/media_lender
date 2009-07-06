require 'IMDB.rb'
require 'fastercsv'

class Movie
  attr_accessor :title, :run_time, :plot, :director, :writer, :link
  attr_accessor :release_date, :rating, :user_comments, :tag_line
  attr_accessor :plot, :genres, :cast, :poster, :keywords, :mpaa
end

class Actor
  attr_accessor :name
  def initialize(name)
    self.name = name
  end
end

class Genre
  attr_accessor :name
  def initialize(name)
    self.name = name
  end
end

class Tag
  attr_accessor :name
  def initialize(name)
    self.name = name
  end
end

start_time = Time.now

movies_str = <<-EOF
10 Things I Hate About You
10,000 BC
12 Rounds
...
EOF

movie_titles = movies_str.split("\n")
puts "Parsing #{movie_titles.length} movies..."

movies = []

movie_titles.each do |movie_title|
  begin
    imdb_movie = IMDB.new(movie_title)
    movie = Movie.new
    movie.title = imdb_movie.title
    movie.poster = imdb_movie.poster_link
    movie.run_time = imdb_movie.runtime 
    movie.plot = imdb_movie.plot 
    movie.director = imdb_movie.director.join(", ") 
    movie.writer = imdb_movie.writer.join(", ") 
    movie.link = imdb_movie.imdb_link 
    movie.release_date = imdb_movie.release_date
    movie.rating = imdb_movie.certification["\nUSA"]
    movie.mpaa = imdb_movie.rating 
    movie.user_comments = imdb_movie.user_comments 
    movie.tag_line = imdb_movie.tagline 
    movie.plot = imdb_movie.plot 
    movie.keywords = imdb_movie.plot_keywords.collect{|kw| Tag.new(kw)}
    movie.genres = imdb_movie.genre.collect{|g| Genre.new(g) }
    movie.cast = imdb_movie.actors.collect{|a| Actor.new(a[0]) }
    movies << movie
  rescue => ex
    puts "\nError thrown on movie '#{movie_title}'"
    puts ex
  end
end

FasterCSV.open("path_to_csv.csv", "w") do |csv|
  csv << ["Title", "Poster Image", "Run Time", "Plot", "Director", "Writer", "IMDB Link", "Release Date", "Rating", "MPAA", "User Comments", "Tag Line", "Keywords", "Genres", "Cast"]
  movies.each do |movie|
    row = []
    row << movie.title
    row << movie.poster
    row << movie.run_time
    row << movie.plot
    row << movie.director
    row << movie.writer
    row << movie.link
    row << movie.release_date.strftime("%m/%d/%Y")
    row << movie.rating
    row << movie.mpaa
    row << movie.user_comments
    row << movie.tag_line
    row << movie.keywords.collect{|t| t.name}.join("|")
    row << movie.genres.collect{|g| g.name}.join("|")
    row << movie.cast.collect{|c| c.name}.join("|")
    csv << row
  end
end

puts "Completed in #{Time.now - start_time} seconds"