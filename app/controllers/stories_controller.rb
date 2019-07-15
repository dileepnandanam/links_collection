class StoriesController < ApplicationController
  def show
  	@script = "mode::hard mode::faster wait::3 mode::fast wait::3 mode::slow wait::3 mode::veryslow wait::3 "
  	# clrscr slow mode::slow wait::3 clrscr fast mode::fast wait::3 clrscr faster mode::faster wait::3 clrscr stop mode::stop"
  end
end