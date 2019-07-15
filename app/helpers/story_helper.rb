module StoryHelper
  def handle_story_element(elem)
    if elem.start_with?('video:')
      %{
        <br />
        <iframe width="100%" height="315" src="#{elem.split(':').last}" frameborder="0" allow="accelerometer; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
      }
    elsif elem.start_with?('image:')
      %{
        <br />
        <img src="#{elem.split(':').last}" />
      }
    elsif elem == 'clrscr'
    	'<span>clrscr</span>'
    else
      %{
      	<span>#{elem}</span>
      }
    end
  end
end
