class UsersController < ApplicationController
  before_action :check_user, only: [:show, :edit, :notifications, :connections, :update, :posts, :disconnect]
  after_action :mark_as_seen, only: [:show]
  def show
  	@chats = get_chats(params[:id])
  	@user = User.find(params[:id])
  	render 'show', layout: false
  end

  def edit
  end

  def switch
    sign_in(:user, User.find(params[:id]))
    redirect_to root_path
  end

  def notifications
    @notifications = current_user.notifications.where(seen: false).order('created_at DESC').all.to_a
    @old = current_user.notifications.where(seen: true).order('created_at DESC').all.to_a
    @notifications.each{|notification| notification.update(seen: true)}
  end

  def connections
    @connections = User.where(id: current_user.connections.map(&:to_user_id) + Connection.where(to_user_id: current_user.id).all - [current_user.id]).uniq

    @unseen_counts = Chat.where(reciver_id: current_user.id, seen: false).group(:sender_id).count('*')

    if params[:user_id]
      @user = User.find(params[:user_id])
      @chats = get_chats(@user.id)
      mark_as_seen
    end
  end

  def update
    if params[:user][:pin].to_s == current_user.pin.to_s
      current_user.update(badwords: params[:user][:badwords])
      flash[:notice] = 'Monitoring Updated'
    else
      flash[:notice] = 'Wrong PIN entered'
    end
    redirect_to root_path
  end

  def posts
    @user = User.find(params[:id])
    @posts = @user.posts.paginate(page: params[:page], per_page: 12)
    @next_path = posts_path(page: (params[:page].present? ? params[:page].to_i + 1 : 2))
  end

  def disconnect
    @user = User.find(params[:id])
    current_user.connections.where(to_user_id: @user.id).delete_all
    redirect_to root_path
  end

  layout 'network'

  protected

  def mark_as_seen
  	unless action_name == 'connections' and params[:user_id].nil?
  	  @chats.update_all(seen: true)
    end
  end

  def get_chats(from_user_id)
    Chat.where("sender_id = ? or reciver_id = ? and sender_id = ? or reciver_id = ?", current_user.id, current_user.id, from_user_id, from_user_id).order('created_at ASC')
  end
end