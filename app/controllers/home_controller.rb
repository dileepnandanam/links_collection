class HomeController < ApplicationController
  before_action :check_user, only: [:dashboard, :responses, :accepted_responses]
  def show
  	@questions = get_questions.paginate(page: 1, per_page: 8)
    if current_user
      @connections = [current_user] + connections_for(current_user)
    else
      @connections = []
    end
  end

  def questions
    @questions = get_questions.paginate(page: params[:page], per_page: 8)
    render 'questions', layout: false
  end

  def dashboard
    @questions = current_user.questions.order('sequence ASC')
    @responses = get_responses.paginate(page: 1, per_page: 2)
 	  @accepted_responses = get_accepted_responses.paginate(page: 1, per_page: 5)
  end

  def responses
    @responses = get_responses.paginate(page: params[:page], per_page: 2)
    render 'responses', layout: false
  end

  def accepted_responses
  	@accepted_responses = get_accepted_responses.paginate(page: params[:page], per_page: 5)
  	render 'accepted_responses', layout: false
  end

  def terms_of_use

  end

  def privacy_policy

  end

  def set_gender
    current_user.update_attributes(gender_params)
  end

  def access_restricted
  end

  layout 'network'

  protected

  def gender_params
    params.require(:user).permit(:gender)
  end

  def get_accepted_responses
  	current_user.posted_responses.where(accepted: true).order('updated_at DESC')
  end

  def get_responses
    responses = current_user.responses.order('id DESC')
    if params[:state] == 'accepted'
      responses.where(accepted: true)
    else
      responses.where(accepted: false)
    end
  end

  def get_questions
    questions = Question.joins(:user).order('id DESC')
    if params[:query]
      questions = questions.joins(:user).where("questions.text ~* '#{params[:query]}' or users.name ~* '#{params[:query]}'")
      "LOWER(questions.text) like LOWER('%#{params[:query]}%') or LOWER(users.name) like LOWER('%#{params[:query]}%')"
    end
    questions
  end
end