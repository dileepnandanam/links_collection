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
      	<span data-type='br'><br /></span>
      }
    elsif elem.start_with? 'mode::'
      %{
      	<span data-mode="#{elem.split('::').last}">mode</span>
      }
    elsif elem.start_with?('inst::')
      %{
        <span data-inst="#{elem.split('::').last.gsub('_', ' ')}">inst</span>
      }
    elsif elem.start_with?('heading::')
      %{
        <span><h1 style="color: #{elem.split('::')[1]}">#{elem.split('::').last.gsub('_', ' ')}</h1></span>
      }
    else
      %{
      	<span>#{elem}</span>
      }
    end
  end
end
