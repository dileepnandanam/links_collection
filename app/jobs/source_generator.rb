class SourceGenerator < ApplicationJob
  queue_as :default
 
  def perform(link)
    link.generate_source_url
  end
end