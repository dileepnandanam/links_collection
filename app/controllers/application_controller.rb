class ApplicationController < ActionController::Base
  def bot_request?
    user_agent =  request.env['HTTP_USER_AGENT'].downcase
    user_agent.index('googlebot')
  end
end
