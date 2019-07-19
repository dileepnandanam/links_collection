class StoriesController < ApplicationController
  def index
  	@stories = Story.all
  end

  def show
  	@story = Story.find(params[:id])
  	@script = @story.text
  	@current = params[:current]
  end

  def create
  	@story = Story.create params.require(:story).permit(:text)
  	render 'edit'
  end

  def new
  	@story = Story.new
  end

  def edit
  	@story = Story.find(params[:id])
  	@current = params[:current]
  end

  def update
  	@current = params[:story][:current]
  	@story = Story.find(params[:id])
  	@story.update params.require(:story).permit(:text, :current)
  	redirect_to edit_story_path(@story, current: @current)
  end
end