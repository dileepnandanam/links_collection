class ResponseMailer < ApplicationMailer
  def new_response
    @user = params[:user]
    @response_user = params[:response_user]
    mail(to: @user.email, subject: 'Response to your questions')
  end

  def response_accepted
  	@user = params[:user]
  	@response_user = params[:response_user]
  	mail(to: @response_user.email, subject: 'Your response got accepted')
  end

  def new_response_to_group
    @response_user = params[:response_user]
    @group = params[:group]
    mail(to: @group.user.email, subject: 'Response to your group')
  end

  def response_to_group_accepted
    @response_user = params[:response_user]
    @group = params[:group]
    mail(to: @response_user.email, subject: 'Your response got accepted')
  end
end
