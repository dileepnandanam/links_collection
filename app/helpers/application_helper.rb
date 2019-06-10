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
end
