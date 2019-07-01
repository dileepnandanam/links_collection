class ApplicationController < ActionController::Base
  before_action :redirect_to_affiliated_site

  def redirect_to_affiliated_site
    url = SiteSetting.where(name: 'affiliate_url').first
    if url.present?
      return redirect_to url.value
    end
  end
end
