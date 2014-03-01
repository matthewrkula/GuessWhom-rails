class PlayerController < ApplicationController
  
  def update
    fb_id = params[:fb_id]
    gcm_id = params[:gcm_id]
    
    if !fb_id || !gcm_id
      return
    end
    
    player = Player.find_by_fb_id(params[:fb_id])
    
    unless player
      player = Player.create(fb_id: params[:fb_id])
    end
    
    player.gcm_id = params[:gcm_id]
    

    respond_to do |format|
      if player.save!
        format.json {render json: {status: '200'}}
      else
        format.json {render json: {status: '400'}}
      end
    end
  end
  
end
