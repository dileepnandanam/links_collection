class LinksController < ApplicationController
  def index
    @link = Link.new
  end

  def search
    @links = Link.where('name ~* ? or tags ~* ? or url ~* ?', params[:q], params[:q], params[:q]).paginate(page: params[:page], per_page: 8)
    render 'search', layout: false
  end

  def create
    @link = Link.new(link_params)
    if @link.name.blank?
      MassEntry.process(@link.url.split(','))
      render plain: 'link(s) created'
    elsif @link.save
      render plain: 'link created'
    else
      render 'new', layout: false, status: 422
    end
  end

  def tag
    link = Link.find(params[:id])
    new_tagset = link.tags + ' ' + params[:value]
    link.update(tags: new_tagset)
  end

  def retry
    render plain: Link.find(params[:id]).generate_source_url
  end

  protected

  def link_params
    params.require(:link).permit(:name, :url, :tags)
  end
end
