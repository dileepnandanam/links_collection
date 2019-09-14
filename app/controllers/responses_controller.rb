class ResponsesController < ApplicationController
  before_action :check_user
  def new
    @user = User.find params[:user_id]
    redirect_to posts_user_path(@user) if current_user.present? && current_user.is_connected_to?(@user)
    @response = Response.new
  	@user.questions.each do |q|
      @response.answers << Answer.new(question_id: q.id)
  	end
  end

  def create
  	@response = Response.create response_params.merge(user_id: current_user.id)
    flash[:notice] = "Requested to connect #{@response.user.name}"
    if @response.responce_user_id == @response.user_id
      @response.delete
    else
      ResponseMailer.with(response_user: @response.responce_user, user: @response.user).new_response.deliver_later
    end
    redirect_to root_path
  end

  def accept
    @response = current_user.responses.find(params[:id])
    @response.update(accepted: true)
    Connection.create(user_id: @response.user_id, to_user_id: @response.responce_user_id)
    Connection.create(to_user_id: @response.user_id, user_id: @response.responce_user_id)
    render 'accept', layout: false
    ResponseMailer.with(user: current_user, response_user: @response.responce_user).response_accepted.deliver_later
  end

  layout 'network'

  protected

  def response_params
    params.require(:response).permit(:responce_user_id, :answers_attributes => [:question_id, :text])
  end
end