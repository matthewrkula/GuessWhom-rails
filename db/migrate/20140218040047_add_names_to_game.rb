class AddNamesToGame < ActiveRecord::Migration
  def change
    add_column :games, :opponent_name, :string
    add_column :games, :creator_name, :string
  end
end
