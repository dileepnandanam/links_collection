class ApplicationController < ActionController::Base
  before_action :current_visitor
  def bot_request?
    user_agent =  request.env['HTTP_USER_AGENT'].downcase
    user_agent.index('googlebot')
  end

  def current_visitor
    return nil if bot_request?
    visitor = nil
    if cookies.permanent.signed[:visitor_id].present?
      visitor = Visitor.where(id: cookies.permanent.signed[:visitor_id]).first
    end

    unless visitor
      visitor = Visitor.create
      cookies.permanent.signed[:visitor_id] = visitor.id
    end

    visitor.update(user_agent: request.env['HTTP_USER_AGENT'].downcase, ip: request.ip)
    visitor
  end
end
