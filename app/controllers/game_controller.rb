class GameController < ApplicationController
  
  def new_game
    obj = Hash.new
    
    obj[:access_token] = params[:access_token]
    
    @graph = Koala::Facebook::API.new(obj[:access_token])
    me = @graph.get_object("me")
    them = @graph.get_object(params[:opponent_id])
    friends = @graph.get_connections("me", "mutualfriends/#{params[:opponent_id]}")
    
    game = Game.new(
      creator_id: me["id"],
      creator_name: me["name"],
      opponent_id: params[:opponent_id],
      opponent_name: them["name"],
      whose_turn: me["id"],
      question: "",
      response: "",
      turn_count: 0,
      winner: "0")
  
    answer = []
    friends = friends.shuffle
    [friends.count, 24].min.times do |i|
      answer << Answer.create(
        name: friends[i]["name"], 
        fb_id: friends[i]["id"],
        game_id: game)
    end
  
    celebrities = [
      {name: "Eminem", fb_id: "45309870078", game_id: game.id},
      {name: "Vin Diesel", fb_id: "89562268312", game_id: game.id},
      {name: "Will Smith", fb_id: "92304305160", game_id: game.id},
      {name: "Beyonce", fb_id: "28940545600", game_id: game.id},
      {name: "Bob Marley", fb_id: "117533210756", game_id: game.id},
      {name: "Jackie Chan", fb_id: "30382852317", game_id: game.id},
      {name: "Jennifer Lopez", fb_id: "5170395767", game_id: game.id},
      {name: "Eric Cartman", fb_id: "100005584694254", game_id: game.id},
      {name: "Kobe Bryant", fb_id: "69025400418", game_id: game.id},
      {name: "Emma Watson", fb_id: "140216402663925", game_id: game.id},
    ]
  
    (24 - friends.count).times do |i|
      answer << Answer.create(celebrities[i%celebrities.length])
    end
  
    answer = answer.shuffle
    24.times do |i|
      answer[i].position = i
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
    
    game.lastquestion = game.question
    game.question = params[:question]
    game.response = params[:response]
    game.turn_count = game.turn_count + 1
    
    if(params[:winner])
      if(params[:winner] != "0")
        game.winner = params[:winner]
      end
    end
    
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
#      games = Game.where("(creator_id = ? AND winner == ?) OR (opponent_id = ? AND winner == ?)", id, "0", id, "0")
      games = Game.where("(creator_id = ?) OR (opponent_id = ?)", id, id)
    else
      games = Game.all
    end
    
    respond_to do |format|
      format.json {render :json => games.to_json(include: {answers: {only: [:fb_id, :name, :position]}})}
    end
  end

end
