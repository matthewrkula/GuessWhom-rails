class RemoveResponseFromGames < ActiveRecord::Migration
  def change
    remove_column :games, :response
  end
end
