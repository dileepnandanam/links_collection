class Groups::QuestionsController < ApplicationController
  before_action :check_user
  before_action :find_group
  def index
    @questions = @group.questions
  end

  def new
    @question = Question.new
    render 'new', layout: false, status: 200
  end

  def edit
    @question = @group.questions.find(params[:id])
    render 'edit', layout: false, status: 200
  end

  def create
    @question = Question.new(question_params.merge(group_id: @group.id, sequence: @group.questions.count))
    if @question.save
      render 'question', layout: false, status: 200
    else
      render 'new', layout: false, status: 422
    end
  end

  def update
    @question = @group.questions.find(params[:id])
    if @question.update(question_params)
      render 'question', layout: false, status: 200
    else
      render 'edit', layout: false, status: 422
    end
  end

  def reorder
    params[:sequence].each_with_index do |id, i|
      @group.questions.find(id).update(sequence: i)
    end
  end

  def destroy
    @question = @group.questions.find(params[:id])
    @question.destroy
  end

  protected

  def find_group
    @group = current_user.groups.find(params[:group_id])
  end

  def question_params
    params.require(:question).permit(:text)
  end
end