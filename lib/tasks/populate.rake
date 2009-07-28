namespace :db do
  namespace :populate do
    
    require 'fastercsv'
    
    def parse_and_create_movie(row, user=nil)
      title = row[0]
      poster_image = row[1]
      run_time = row[2]
      plot = row[3]
      director = row[4]
      writer = row[5]
      imdb_link = row[6]
      release_date = row[7]
      rating = row[8]
      mpaa = row[9]
      user_comments = row[10]
      tag_link = row[11]
      keywords = row[12].split("|")
      genres = row[13].split("|")
      cast = row[14].split("|")

      m = user ? user.movies.new : Movie.new
      m.title = title
      m.genre = genres[0]
      m.rating = rating.blank? ? "Unrated" : rating
      m.synopsis = plot
      m.save
    end
    
    desc "Erase and fill database with movie data (for tag 1.0)"
    task :one => :environment do
      Movie.delete_all
      FasterCSV.foreach("#{RAILS_ROOT}/mock_data/erics_movies.csv") do |row|
        next if row[0] == "Title"
        parse_and_create_movie(row)
      end
    end
    
    desc "Erase and fill database with a single user's movie data (for tag 3.0)"
    task :three => :environment do
      User.delete_all
      user = User.create(
        :first_name => "Eric", 
        :last_name => "Berry", 
        :email => "eric@berry.com",
        :login => "eric", 
        :password => "test",
        :password_confirmation => "test"
      )
      
      Movie.delete_all
      FasterCSV.foreach("#{RAILS_ROOT}/mock_data/erics_movies.csv") do |row|
        next if row[0] == "Title"
        parse_and_create_movie(row, user)
      end
    end
    
    desc "Add an additional user"
    task :four => :environment do

      user = User.find_by_email("jisraelsen@gmail.com")
      if user.nil?
        user = User.new(
          :first_name => "Jeremy",
          :last_name => "Israelsen",
          :email => "jisraelsen@gmail.com",
          :login => "jeremy",
          :password => "test",
          :password_confirmation => "test"
        )
        user.save
      end 

      titles = [
        "Return to the Blue Lagoon",
        "Must Have Dogs",
        "Three Amigos!",
        "Barbarella",
        "Ernest Goes to Jail"
      ]

      titles.each do |title|
        begin
          imdb_movie = IMDB.new(title)
          movie = Movie.new
          movie.user_id = user.id
          movie.rating = imdb_movie.certification["\nUSA"]
          movie.title = title
          movie.genre = imdb_movie.genre.first
          movie.synopsis = imdb_movie.plot
          movie.save!
        rescue => ex
          puts "\nError thrown on movie '#{title}'"
          puts ex
        end
      end

    end
    
  end
end