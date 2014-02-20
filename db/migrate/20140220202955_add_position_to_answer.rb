class AddPositionToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :position, :integer
  end
end
