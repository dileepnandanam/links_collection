module StoryHelper
  def handle_story_element(elem)
    if elem.start_with?('video::')
      %{
        <br />
        <video src="#{elem.split('::').last}"></video>
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
    elsif elem.start_with? 'bg::'
      %{
        <span data-src=#{elem.split('::').last}>bg</span>
      }
    elsif elem == '|'
      %{
      	<br />
      }
    else
      %{
      	<span>#{elem}</span>
      }
    end
  end
end
