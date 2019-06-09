module ApplicationHelper
  def youtube_embed_code(url)
    %{
    	<iframe width="560" height="315" src="#{url}" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
    }.html_safe
  end
end
