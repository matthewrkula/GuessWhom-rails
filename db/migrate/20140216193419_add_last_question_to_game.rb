class AddLastQuestionToGame < ActiveRecord::Migration
  def change
    add_column :games, :lastquestion, :string
  end
end
