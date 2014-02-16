class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :creator_id
      t.string :opponent_id
      t.string :whose_turn
      t.string :question
      t.string :response
      t.string :creator_answer
      t.string :opponent_answer

      t.timestamps
    end
  end
end
