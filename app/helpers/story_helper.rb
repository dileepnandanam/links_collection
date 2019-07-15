module StoryHelper
  def handle_story_element(elem)
    if elem.start_with?('video::')
      %{
        <br />
        <iframe width="560" height="315" src="#{elem.split('::').last}" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
      }
    elsif elem.start_with?('image::')
      %{
        <br />
        <img src="#{elem.split('::').last}" />
      }
    elsif elem == 'clrscr'
    	'<span>clrscr</span>'
    elsif elem.start_with? 'wait::'
    	%{
    	  <span data-wait=#{elem.split('::').last.to_i * 1000}>wait</span>
    	}
    else
      %{
      	<span>#{elem}</span>
      }
    end
  end
end
