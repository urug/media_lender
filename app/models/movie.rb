class Movie < ActiveRecord::Base
  RATINGS = %w[Unrated G PG PG-13 R NC-17]
  GENRES  = %w[Action/Adventure Comedy SciFi]
end
