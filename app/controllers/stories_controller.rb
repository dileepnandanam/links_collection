class StoriesController < ApplicationController
  def show
  	@script = %{

  		p
  		wait::4
  		clrscr
  	}
  end
end