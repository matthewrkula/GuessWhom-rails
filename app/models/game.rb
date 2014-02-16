class Game < ActiveRecord::Base
  
  has_many :answers
  
  validates :creator_id, presence: true
  validates :opponent_id, presence: true
  validates :whose_turn, presence: true
  validates :creator_answer, presence: true
  validates :opponent_answer, presence: true

end
