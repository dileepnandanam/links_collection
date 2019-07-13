class LinksController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_orientation, only: [:index, :search]
  def index
    @link = Link.new
    per_page = bot_request? ? 100 : 8
    if params[:q].present?
      @links = Link.search(params[:q], orientation).paginate(page: params[:page], per_page: per_page)
      @count = Link.search_count params[:q]
      if params[:crawl].present?
        Searcher.perform_later params[:q] 
      end
    else
      @links = Link.normal.with_orientation(orientation).limit(8).paginate(per_page: per_page, page: 1)
      @count = Link.normal.with_orientation(orientation).count
    end
  end

  def search
    if params[:q].present?
      @links = Link.search(params[:q], orientation).order('created_at DESC').paginate(page: params[:page], per_page: 8)
      @count = Link.search_count params[:q]
      #if @links.blank? || @links.next_page.blank?
      if params[:crawl].present?  
        Searcher.perform_later params[:q] 
      elsif params[:random].present?
        @links = Link.normal.with_orientation(orientation).order(Arel.new('random()')).limit(8).paginate(per_page: 8, page: 1)
      end
    else
      @links = Link.normal.with_orientation(orientation).paginate(per_page: 8, page: params[:page])
    end
    render 'search', layout: false
  end

  def hidden
    if current_user.try :admin?
      @links = Link.unscoped.where(hidden: true).paginate(per_page: 8, page: params[:page])
    else
      redirect_to root_path
    end
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

  def destroy
    if current_user.admin?
      Link.unscoped.find(params[:id]).delete
    end
  end

  def hide
    if current_user.admin?
      @link = Link.find(params[:id])
      @link.update(hidden: true)
      render 'hide', layout: false
    end
  end

  def unhide
    if current_user.admin?
      @link = Link.unscoped.find(params[:id])
      @link.update(hidden: false)
      render 'hide', layout: false
    end
  end

  def untag
    link = Link.unscoped.find(params[:id])
    if current_user.admin?
      link.update(tags: link.tags.gsub(params[:tag].strip, ''))
    end
  end

  protected

  def orientation
    @orientation = cookies[:orientation]
  end

  def set_orientation
    if params[:orientation].present?
      cookies[:orientation] = params[:orientation]
    end
  end
  def link_params
    params.require(:link).permit(:name, :url, :tags)
  end
end
