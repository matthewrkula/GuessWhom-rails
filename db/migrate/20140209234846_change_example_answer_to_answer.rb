class ChangeExampleAnswerToAnswer < ActiveRecord::Migration
  def change
    rename_table :example_answers, :answers
  end
end
