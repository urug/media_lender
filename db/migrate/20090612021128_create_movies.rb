class CreateMovies < ActiveRecord::Migration
  def self.up
    create_table :movies do |t|
      t.string :title
      t.string :rating
      t.string :genre
      t.text :synopsis

      t.timestamps
    end
  end

  def self.down
    drop_table :movies
  end
end
