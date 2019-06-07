class UsersController < ApplicationController
  before_action :check_user
  def show
    @user = User.where(gender: params[:gender], online: true).order(Arel.sql('random()')).first
  	@chats = get_chats(@user.id)
  	render 'show', layout: false
  end

  def connections
    if params[:user_id]
      @user = User.find(params[:user_id])
      @chats = get_chats(@user.id)
    end
  end

  protected

  def get_chats(from_user_id)
    Chat.where("sender_id = ? or reciver_id = ? and sender_id = ? or reciver_id = ?", current_user.id, current_user.id, from_user_id, from_user_id).order('created_at ASC')
  end
end