class CreateExampleAnswers < ActiveRecord::Migration
  def change
    create_table :example_answers do |t|
      t.string :name
      t.string :fb_id
      t.belongs_to :game
      t.timestamps
    end
  end
end
