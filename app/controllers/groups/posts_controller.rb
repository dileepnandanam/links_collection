class Groups::PostsController < ApplicationController
  before_action :check_user
  before_action :check_membership
  def show
    @post = Post.find(params[:id])
  end

  def index
    @group = Group.find(params[:group_id])
    @posts = @group.posts.order('created_at DESC').paginate(per_page: 2, page: params[:page])
    render 'index', layout: false
  end

  def new
    @post = Post.new
    @group = Group.find(params[:group_id])
    render 'new', layout: false
  end

  def create
    @group = Group.find(params[:group_id])
    @post = @group.posts.create(post_params.merge(user_id: current_user.id))
    render 'post', layout: false
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy
  end

  def upvote
    @post = Post.find(params[:id])
    current_vote = @post.votes.where(user_id: current_user.id).first
    if current_vote
      current_vote.delete      
    end
    Vote.create(user_id: current_user.id, post_id: params[:id], weight: 1)
    render 'votes', layout: false
  end

  def downvote
    @post = Post.find(params[:id])
    current_vote = @post.votes.where(user_id: current_user.id).first
    if current_vote
      current_vote.delete
    end
    Vote.create(user_id: current_user.id, post_id: params[:id], weight: -1)
    render 'votes', layout: false
  end

  protected

  def check_membership
    group = Group.find params[:group_id]
    unless group.responses.where(responce_user_id: current_user.id).first || group.user_id == current_user.id
      redirect_to access_restricted_path
    end
  end  

  def post_params
    params.require(:post).permit(:text, :image, :title)
  end
end