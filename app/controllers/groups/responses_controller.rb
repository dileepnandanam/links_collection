class Groups::ResponsesController < ApplicationController
  before_action :check_user, only: [:create, :accept]
  before_action :authenticate_user!, only: [:new]
  before_action :find_group
  def new
    @response = Response.new
  	@group.questions.each do |q|
      @response.answers << Answer.new(question_id: q.id)
  	end
  end

  def create
  	@response = Response.create response_params.merge(responce_user_id: current_user.id, group_id: @group.id)
    flash[:notice] = "Requested to join #{@response.group.name}'s questions"
    if @response.responce_user_id == @response.group.user_id
      @response.delete
    else
      ResponseMailer.with(response_user: @response.responce_user, group: @response.group).new_response_to_group.deliver_later
    end
    redirect_to root_path
  end

  def accept
    unless @group.user == current_user
      redirect_to access_restricted_path
    end
    @response = @group.responses.find(params[:id])
    @response.update(accepted: true)
    render 'accept', layout: false
    ResponseMailer.with(group: @group, response_user: @response.responce_user).response_to_group_accepted.deliver_later
  end

  protected

  def find_group
    @group = Group.find(params[:group_id])
  end

  def response_params
    params.permit(:response).permit(:user_id, :answers_attributes => [:question_id, :text])
  end
end