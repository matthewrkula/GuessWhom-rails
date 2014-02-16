class AddResponseToGames < ActiveRecord::Migration
  def change
    add_column :games, :response, :string
  end
end
