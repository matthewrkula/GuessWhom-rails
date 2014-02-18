class AddIsCompletedToGame < ActiveRecord::Migration
  def change
    add_column :games, :is_completed, :boolean
  end
end
