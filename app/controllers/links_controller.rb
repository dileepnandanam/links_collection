class LinksController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    @link = Link.new
  end

  def search
    if params[:q].present?
      @links = Link.search(params[:q]).order('created_at DESC').paginate(page: params[:page], per_page: 8)
    else
      @links = Link.not(where("tags ~* #{'dik'.reverse}")).order(Arel.sql('random()')).limit(20).paginate(per_page: 20, page: 1)
    end
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
