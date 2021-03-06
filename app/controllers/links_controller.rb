class LinksController < ApplicationController
  after_action :popup_seen
  skip_before_action :verify_authenticity_token
  before_action :set_orientation, only: [:index, :search]
  def index
    @link = Link.new
    per_page = bot_request? ? 100 : 20
    if params[:q].present?
      @links = Link.search(params[:q], orientation).paginate(page: params[:page], per_page: per_page)
      @count = Link.search_count params[:q], orientation
      if params[:crawl].present?
        Searcher.perform_later params[:q] 
      end
    elsif params[:video_id].present?
      @links = Link.where(hidden: false, id: params[:video_id]).paginate(per_page: 1, page: 1)
      @count = 1
    else
      @links = Link.normal.with_orientation(orientation).limit(8).paginate(per_page: per_page, page: 1)
      @count = Link.normal.count
    end
  end

  def show
    @link = Link.find(params[:id])
  end

  def search
    if request.format.html?
      redirect_to root_path(q: params[:q])
    else
      if params[:q].present?
        @links = Link.search(params[:q], orientation, params[:order]).paginate(page: params[:page], per_page: 20)
        @count = Link.search_count params[:q], orientation
        #if @links.blank? || @links.next_page.blank?
        if params[:crawl].present?
          Searcher.perform_later params[:q]
        elsif params[:random].present?
          @links = Link.normal.with_orientation(orientation).order(Arel.new('random()')).paginate(per_page: 20, page: 1)
        end
      else
        @links = Link.normal.with_orientation(orientation).paginate(per_page: 20, page: params[:page])
      end
      render 'search', layout: false
    end
  end

  def comments
    @link = Link.unscoped.find(params[:id])
    @comments = @link.comments
    render 'comment_section', layout: false
  end

  def create_comment
    comment_params = params.require(:comment).permit(:kind, :text)
    link_id = params[:id]
    @Link = Link.find(link_id)
    @comment = @Link.comments.create(comment_params.merge(user_id: current_user.id, kind: 'videoresponse', post_id: link_id))
    render 'posts/comments/comment', layout: false
  end

  def hidden
    if true
      @links = Link.unscoped.where(hidden: true).paginate(per_page: 8, page: params[:page])
    else
      redirect_to root_path
    end
  end

  def mark_fav
    if true
      @link = Link.unscoped.find(params[:id])
      @link.update(favourite: !@link.favourite)
      render 'hide', layout: false
    end
  end

  def mark_nsfw
    link = Link.find(params[:id])
    link.update(nsfw: true) if link.nsfw
    link.update(nsfw: false) if link.nsfw
    render head: :ok
  end

  def feature
    featuring = Link.find(params[:id])
    if featuring.present? && current_user.try(:admin?)
      current = Link.where(featured: true).first
      current.update(featured: false) if current.present?
      featuring.update(featured: true)
    end
    render plain: 'ok'
  end

  def favourite
    @links = Link.favourite.paginate(per_page: 8, page: params[:page])
    @count = Link.favourite.count
    render plain: 'made to favourite list'
  end

  def create
    @link = Link.new link_params
    if @link.save
      redirect_to links_path(video_id: @link.id)
    else
      render 'new', layout: false, status: 422
    end
  end

  def tag
    link = Link.find(params[:id])
    new_tagset = link.tags.to_s + ' ' + params[:value]
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
    if true
      @link = Link.unscoped.find(params[:id])
      @link.update(hidden: true)
      render 'hide', layout: false
    end
  end

  def hide
    if true
      @link = Link.unscoped.find(params[:id])
      @link.update(hidden: true)
      render 'hide', layout: false
    end
  end

  def report
      @link = Link.find(params[:id])
      render json: {message: 'report success'}
  end

  def unhide
    if current_user && current_user.admin?
      @link = Link.unscoped.find(params[:id])
      @link.update(hidden: false)
      render 'hide', layout: false
    end
  end

  def untag
    link = Link.unscoped.find(params[:id])
    if current_user && current_user.admin?
      link.update(tags: link.tags.gsub(params[:tag].strip, ''))
    end
  end

  def statistics
    render json: {
      daily: Visitor.where(created_at: 1.days.ago..Time.now).count
    } 
  end

  def set_nsfw
    link = Link.find(params[:id])
    link.update(nsfw: !link.nsfw)
    render plain: "OK"
  end

  protected

  def popup_seen
    cookies[:popup_seen] = true
  end

  def orientation
    @orientation = cookies[:orientation]
    @orientation
  end

  def set_orientation
    if params[:orientation].present?
      cookies[:orientation] = params[:orientation]
    elsif params[:q].to_s.include?('gay')
      cookies[:orientation] = 'gay'
    elsif params[:q].to_s.include?('lesb')
      cookies[:orientation] = 'lesbian'
    elsif params[:q].to_s.include?('straight')
      cookies[:orientation] = nil
    end
  end

  def link_params
    params.require(:link).permit(:name, :url, :tags, :text, :body)
  end
end
