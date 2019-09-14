class Groups::Posts::CommentsController < ApplicationController
  before_action :check_user
  before_action :check_membership
  def new
  	@group = Group.find(params[:group_id])
    @post = Post.find(params[:post_id])
    @comment = Comment.new
    @parent_id = params[:parent_id]
    render 'new', layout: false
  end

  def index
  	@post = Post.find(params[:post_id])
  	@comments = @post.comments.where(parent_id: params[:parent_id]).paginate(page: params[:page], per_page: 5)
  	render 'comments', layout: false
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(comments_params.merge(user_id: current_user.id))
    render 'comment', layout: false
  end

  def destroy
  	@comment = current_user.comments.find(params[:id]).destroy
  end

  def upvote
    @post = @comment = Comment.find(params[:id])
    current_vote = @comment.votes.where(user_id: current_user.id).first
    if current_vote
      current_vote.delete      
    end
    Vote.create(user_id: current_user.id, comment_id: params[:id], weight: 1)
    render 'groups/posts/votes', layout: false
  end

  def downvote
    @post = @comment = Comment.find(params[:id])
    current_vote = @comment.votes.where(user_id: current_user.id).first
    if current_vote
      current_vote.delete      
    end
    Vote.create(user_id: current_user.id, comment_id: params[:id], weight: -1)
    render 'groups/posts/votes', layout: false
  end

  protected

  def comments_params
  	params.require(:comment).permit(:text, :parent_id)
  end

  def check_membership
    group = Group.find params[:group_id]
    unless group.responses.where(responce_user_id: current_user.id).first || group.user_id == current_user.id
      redirect_to access_restricted_path
    end
  end
end