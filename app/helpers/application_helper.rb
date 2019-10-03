module ApplicationHelper
  def thumb_class(url)
    url = url.start_with?('http') ? url.rstrip : "http://#{uri}".rstrip
    uri = URI.parse(url.rstrip)
    host = uri.host
    subdomine = host.split('.')[-2]
  end

  def display_for_bot
    user_agent =  request.env['HTTP_USER_AGENT'].downcase
    if user_agent.index('googlebot')
      yield
    end
  end

  def default_banner
    %{https://media.architecturaldigest.com/photos/5ced629704c41e1a9b9a8bcf/16:9/w_1280,c_limit/Bugatti-LVN-7%2520%255BBugatti%255D.jpg}
  end

  def default_background
    'https://komonews.com/resources/media/46ac9d95-54a7-4cea-829d-8834c73f293b-large16x9_190207_loz_snowfall_sunset_1940.jpg?1549572251633'
  end
  
  def youtube_embed_code(url)
    %{
    	<iframe width="560" height="315" src="#{url}" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
    }.html_safe
  end

  def xnxx_embed_code(url)
  	%{
  		<iframe src="#{url}" controll="true" frameborder=0 width=510 height=400 scrolling=no allowfullscreen=allowfullscreen></iframe>
  	}.html_safe
  end

  def bot_request?
    user_agent =  request.env['HTTP_USER_AGENT'].downcase
    user_agent.index('googlebot')
  end

  def intel_title
    teaser = nil
    teaser = "Home made #{params[:q]}" if params[:q].present?
    [teaser.to_s, "#{@links.try(:first).try(:name) || 'gillet blade'}"].join(' ')
  end

  def result_description
    if bot_request?
      bot_links = Link.all.map(&:tags).join(" ").split(" ").uniq
      %{<h1 class='name'>Real Homemade #{params[:q]}</h1> <a class='name'> #{params[:q]} at its best</a> #{bot_links.map{|l| "<a class='tag' href='/?q="+l+"'>"+l+"</a>"}.join(' ')}}
    end
  end

  def bg_style
    if bot_request?
      "background-color: yellow"
    else
      "background-image: url('https://wallpapercave.com/wp/BW05kLc.jpg');"
    end
  end
end
