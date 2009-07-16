class Movie < ActiveRecord::Base
  belongs_to :user
  named_scope :family_friendly, :conditions=>"rating in ('G', 'PG')"
  
  validates_presence_of :user_id, :title, :rating, :genre
  validates_uniqueness_of :title, :scope => :user_id
      
  RATINGS = %w[Unrated G PG PG-13 R NC-17]
  GENRES  = %w[Action Adventure Comedy Crime/Gangster Drama Historical Horror Musical SciFi War Western]
  
  named_scope :all_by_letter, lambda { |letter| { :conditions => "title LIKE '#{letter}%'" } }
  named_scope :all_by_numbers, :conditions => ("A".."Z").map { |letter| "title NOT LIKE '#{letter}%'" }.join(" AND ")
end
