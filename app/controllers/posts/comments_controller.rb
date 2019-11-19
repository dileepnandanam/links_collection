class Posts::CommentsController < ApplicationController

  def index
    @post = Post.find(params[:post_id])
    @comments = @post.comments.for_post.where(parent_id: params[:parent_id]).paginate(page: params[:page], per_page: 5)
    @comments = FilterPost.filter(@comments,[:text], current_user.try(:badwords))
    render 'comments', layout: false
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.for_post.create(comments_params.merge(user_id: current_user.id))
    render 'posts/comments/comment', layout: false
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
    Vote.create(user_id: current_user.id, comment_id: params[:id], weight: 1) if @comment.user != current_user
    render 'posts/comment_actions', layout: false
  end

  def downvote
    @post = @comment = Comment.find(params[:id])
    current_vote = @comment.votes.where(user_id: current_user.id).first
    if current_vote
      current_vote.delete      
    end
    Vote.create(user_id: current_user.id, comment_id: params[:id], weight: -1) if @comment.user != current_user
    render 'posts/comment_actions', layout: false
  end

  protected

  def comments_params
    params.require(:comment).permit(:text, :parent_id)
  end
end