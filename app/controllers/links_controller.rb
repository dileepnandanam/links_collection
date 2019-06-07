class LinksController < ApplicationController
  def index
    @link = Link.new
  end

  def search
    @links = Link.where('text ~* ? or tags ~* ? or url ~* ?', params[:q], params[:q], params[:q]).paginate(page: params[:page], per_page: 20)
    render 'search', layout: false
  end

  def create
    @link = Link.new(link_params)
    if @link.save
      render plain: 'link created'
    else
      render 'new', layout: false, status: 422
    end
  end

  protected

  def link_params
    params.require(:link).permit(:name, :url, :tags)
  end
end
