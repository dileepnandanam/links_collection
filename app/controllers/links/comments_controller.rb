class Links::CommentsController < ApplicationController
  def new
    @comment = (params[:class_name]||'Comment').camelize.constantize.find(params[:comment_id])
    @comment = Comment.new
    @parent_id = params[:parent_id]
    render 'links/comments/new', layout: false
  end

  def index
    @comment = Comment.find(params[:comment_id])
    @comments = @comment.comments.for_comment.where(parent_id: params[:parent_id]).paginate(page: params[:page], per_page: 5)
    @comments = FilterComment.filter(@comments,[:text], current_visitor.try(:badwords))
    render 'comments', layout: false
  end

  def create
    @comment = Comment.create(comments_params.merge(user_id: current_visitor.id))
    @comment.anonymous = true
    render 'links/comments/comment', layout: false
  end

  def destroy
    @comment = current_visitor.comments.find(params[:id]).destroy
  end

  def upvote
    @comment = @comment = Comment.find(params[:id])
    current_vote = @comment.votes.where(user_id: current_visitor.id).first
    if current_vote
      current_vote.delete      
    end
    Vote.create(user_id: current_visitor.id, comment_id: params[:id], weight: 1) if @comment.user != current_visitor
    render 'comments/comment_actions', layout: false
  end

  def downvote
    @comment = @comment = Comment.find(params[:id])
    current_vote = @comment.votes.where(user_id: current_visitor.id).first
    if current_vote
      current_vote.delete      
    end
    Vote.create(user_id: current_cisitor.id, comment_id: params[:id], weight: -1) if @comment.user != current_visitor
    render 'comments/comment_actions', layout: false
  end

  protected

  def comments_params
    params.require(:comment).permit(:text, :parent_id)
  end
end