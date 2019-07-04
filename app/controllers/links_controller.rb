class LinksController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    @link = Link.new
    if params[:q].present?
      @links = Link.search(params[:q]).paginate(page: params[:page], per_page: 8)
      if params[:crawl].present?  
        Searcher.perform_later params[:q] 
      end
    else
      @links = Link.normal.limit(8).paginate(per_page: 8, page: 1)
    end
  end

  def search
    if params[:q].present?
      @links = Link.search(params[:q]).order('created_at DESC').paginate(page: params[:page], per_page: 8)
      #if @links.blank? || @links.next_page.blank?
      if params[:crawl].present?  
        Searcher.perform_later params[:q] 
      end
    else
      @links = Link.normal.limit(8).paginate(per_page: 8, page: 1)
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
    render plain: Link.find(params[:id]).generate_source_url_now
  end

  def desc
    TextRecord.where(name: 'meta_desc').first_or_create.update(value: params.permit(:value)[:value])
    render plain: params[:value]
  end

  protected

  def link_params
    params.require(:link).permit(:name, :url, :tags)
  end
end
