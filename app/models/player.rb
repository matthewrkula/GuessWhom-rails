class Player < ActiveRecord::Base
  validates :fb_id, presence: true
end