class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :current_visitor
  
  protected
  
    def bot_request?
      user_agent =  request.env['HTTP_USER_AGENT'].downcase
      user_agent.index('googlebot')
    end

    def current_visitor
      return nil if bot_request?
      visitor = nil
      if cookies.permanent.signed[:visitor_id].present?
        visitor = Visitor.where(id: cookies.permanent.signed[:visitor_id]).first
        visitor.update(last_seen: Time.now)
      end

      unless visitor
        visitor = Visitor.create
        cookies.permanent.signed[:visitor_id] = visitor.id
      end

      visitor.update(user_agent: request.env['HTTP_USER_AGENT'].downcase, ip: request.ip)
      visitor
    end
    
    def connections_for(user)
    	connections = (
        user.responses.where(accepted: true).map(&:responce_user) +
        user.posted_responses.where(accepted: true, group_id: nil).map(&:user)
      ).uniq
    end

    def check_user
      unless current_user
        redirect_to access_restricted_path and return
      end
    end

    def authenticate_user!
      unless current_user.present?
        session[:after_sign_in_path] = request.url
        redirect_to user_facebook_omniauth_authorize_path
      end
    end

    def after_sign_in_path_for(resource)
      if session[:after_sign_in_path]
        session.delete(:after_sign_in_path)
      else
        root_path
      end
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :image, :name, :pin, :gender])
    end

    def to_new_app
      if Rails.env.production?
        redirect_to request.url.replace('xlinks.herokuapp.com', 'faqfacebook.com') if request.host.include?('xlinks.herokuapp.com')
      end
    end
end
