class GameController < ApplicationController
  
  def new_game
    obj = Hash.new
    
    obj[:access_token] = params[:access_token]
    
    @graph = Koala::Facebook::API.new(obj[:access_token])
    me = @graph.get_object("me")
    friends = @graph.get_connections("me", "mutualfriends/#{params[:opponent_id]}")
    
    game = Game.new(
      :creator_id => me["id"],
      :opponent_id => params[:opponent_id],
      :whose_turn => me["id"],
      :question => "",
      :response => "")
  
    answer = []
  
    [friends.count, 24].min.times do |i|
      answer << Answer.create(
        name: friends[i]["name"], 
        fb_id: friends[i]["id"],
        game_id: game)
    end
  
    (24 - friends.count).times do |i|
      answer << Answer.create(name: "eminem", fb_id: "45309870078", game_id: game.id)
    end
  
    game.answers = answer
    game.creator_answer = game.answers[rand(24)]["fb_id"]
    game.opponent_answer = game.answers[rand(24)]["fb_id"]
  
    respond_to do |format|
      if game.save!
        format.json {render :json => game.to_json(include: :answers)}
      else
        format.json {render :json => {error: "Bad inputs"}}
      end
    end
  end

  def update
    game = Game.find(params[:id])
    
    game.question = params[:question]
    game.response = params[:response]
    
    if game.whose_turn.eql? game.creator_id
      game.whose_turn = game.opponent_id
    else
      game.whose_turn = game.creator_id
    end
    
    respond_to do |format|
      if game.save!
        format.json {render :json => game}
      else
        format.json {render :json => {error: "Bad inputs"}}
      end
    end
    
  end

  
  def index
    id = params[:user_id]
    if id
      games = Game.where("creator_id = ? OR opponent_id = ?", id, id)
    else
      games = Game.all
    end
    
    respond_to do |format|
      format.json {render :json => games.to_json(include: {answers: {only: [:fb_id, :name]}})}
    end
  end

end
