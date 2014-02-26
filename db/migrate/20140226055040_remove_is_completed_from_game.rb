class RemoveIsCompletedFromGame < ActiveRecord::Migration
  def change
    remove_column :games, :is_completed
  end
end
