class Movie < ActiveRecord::Base
  validates_presence_of :title, :rating, :genre
  validates_uniqueness_of :title # scope to follow
  
  RATINGS = %w[Unrated G PG PG-13 R NC-17]
  GENRES  = %w[Action Adventure Comedy Crime/Gangster Drama Historical Horror Musical SciFi War Western]
end
