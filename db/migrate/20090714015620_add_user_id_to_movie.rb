class AddUserIdToMovie < ActiveRecord::Migration
  def self.up
    add_column :movies, :user_id, :integer
    
    add_index :movies, :user_id
  end

  def self.down
    remove_column :movies, :user_id
  end
end
