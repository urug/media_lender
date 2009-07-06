class Movie < ActiveRecord::Base
  validates_presence_of :title, :rating, :genre
  validates_uniqueness_of :title # scope to follow
      
  RATINGS = %w[Unrated G PG PG-13 R NC-17]
  GENRES  = %w[Action Adventure Comedy Crime/Gangster Drama Historical Horror Musical SciFi War Western]
  
  named_scope :all_by_letter, lambda { |letter|
        { :conditions => "title LIKE '#{letter}%'" }
      }
  
  def self.all_by_numbers
    conditions = []
    ("A".."Z").each do |letter|
      conditions << "(title NOT LIKE '#{letter}%')"
    end
    Movie.find(:all, :conditions => conditions.join(" AND "))
  end
end
