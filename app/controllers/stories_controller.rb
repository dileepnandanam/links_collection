class StoriesController < ApplicationController
  def show
  	@script = params[:script] || ''
  end
end