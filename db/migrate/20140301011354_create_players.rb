class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :fb_id
      t.string :gcm_id

      t.timestamps
    end
  end
end
