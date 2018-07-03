require 'parse'

class KakaoController < ApplicationController
  def keyboard
    @keyboard = {
        :type => "buttons",
        :buttons => ["메뉴", "로또", "고양이"]
    }
    
    render json: @keyboard
    
  end
  
  def message
    @user_msg = params[:content]
    @text = "기본응답"
    if @user_msg == "메뉴"
      @text = ["20층","멀캠식당","급식"].sample
    elsif @user_msg == "로또"
      @text = (1..45).to_a.sample(6).sort.to_s
    elsif @user_msg == "고양이"
      @cat_url = Parse::Animal.cat
    end
    
    
    @return_msg ={
      :text => @text
    }
    @return_msg_photo = {
      :text => "나만 고양이 없어 :(",
      :photo => {
        :url => @cat_url,
        :width => 720,
        :height => 630
        
      }
    }
    
    @return_keyboard = {
        :type => "buttons",
        :buttons => ["메뉴", "로또", "고양이"]
    }
    
    if @user_msg == "고양이"
      @result = {
        :message => @return_msg_photo,
        :keyboard => @return_keyboard
      }
    else
      @result = {
        :message => @return_msg,
        :keyboard => @return_keyboard
      }
    end
    
    render json: @result
  end
  
  def friend_add
    User.create(user_key: params[:user_key], chat_room: 0)
    render nothing: true
  end
  
  def friend_delete
    User.find_by(user_key: params[:user_key]).destroy
    render nothing: true
  end
  
  def chat_room
    user = User.find_by(user_key: params[:user_key])
    user.plus
    user.save
    render nothing: true
  end
  
end
