class QuestionsController < ApplicationController
  before_action :check_user, only: [:create, :update, :reorder, :destroy]
  def new
    @question = Question.new
    render 'new', layout: false, status: 200
  end

  def edit
    @question = current_user.questions.find(params[:id])
    render 'edit', layout: false, status: 200
  end

  def create
    @question = Question.new(question_params.merge(user_id: current_user.id, sequence: current_user.questions.count))
    if @question.save
      render 'question', layout: false, status: 200
    else
      render 'new', layout: false, status: 422
    end
  end

  def update
    @question = current_user.questions.find(params[:id])
    if @question.update(question_params)
      render 'question', layout: false, status: 200
    else
      render 'edit', layout: false, status: 422
    end
  end

  def reorder
    params[:sequence].each_with_index do |id, i|
      current_user.questions.find(id).update(sequence: i)
    end
  end

  def destroy
    @question = current_user.questions.find(params[:id])
    @question.destroy
  end

  layout 'network'

  protected

  def question_params
    params.require(:question).permit(:text)
  end
end