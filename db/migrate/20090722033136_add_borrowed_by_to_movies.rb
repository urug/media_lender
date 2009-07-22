class AddBorrowedByToMovies < ActiveRecord::Migration
  def self.up
    add_column :movies, :borrowed_by, :integer
    add_column :movies, :borrowed_at, :datetime
  end

  def self.down
    remove_column :movies, :borrowed_at
    remove_column :movies, :borrowed_by
  end
end
