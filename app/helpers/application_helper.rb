module ApplicationHelper
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
    [teaser.to_s, "#{@links.try(:first).try(:name) || 'codegasm '}"].join(' ')
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
